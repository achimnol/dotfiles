#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Bottle is a fast and simple micro-framework for small web applications. It
offers request dispatching (Routes) with url parameter support, templates,
a built-in HTTP Server and adapters for many third party WSGI/HTTP-server and
template engines - all in a single file and with no dependencies other than the
Python Standard Library.

Homepage and documentation: http://bottlepy.org/

Copyright (c) 2011, Marcel Hellkamp.
License: MIT (see LICENSE for details)


Additional Note:
This is a modified version to use the templating part *only*,
by Joongi Kim <me@daybreaker.info>.
"""

from __future__ import with_statement

__author__ = 'Marcel Hellkamp'
__version__ = '0.11.dev'
__license__ = 'MIT'


import functools, os, re, sys, threading, warnings

try: from json import dumps as json_dumps, loads as json_lds
except ImportError: # pragma: no cover
    try: from simplejson import dumps as json_dumps, loads as json_lds
    except ImportError:
        try: from django.utils.simplejson import dumps as json_dumps, loads as json_lds
        except ImportError:
            def json_dumps(data):
                raise ImportError("JSON support requires Python 2.6 or simplejson.")
            json_lds = json_dumps

# We now try to fix 2.5/2.6/3.1/3.2 incompatibilities.
# It ain't pretty but it works... Sorry for the mess.

py   = sys.version_info
py3k = py >= (3,0,0)
py25 = py <  (2,6,0)
py31 = (3,1,0) <= py < (3,2,0)

# Workaround for the "print is a keyword/function" Python 2/3 dilemma
# and a fallback for mod_wsgi (resticts stdout/err attribute access)
try:
    _stdout, _stderr = sys.stdout.write, sys.stderr.write
except IOError:
    _stdout = lambda x: sys.stdout.write(x)
    _stderr = lambda x: sys.stderr.write(x)

# Lots of stdlib and builtin differences.
if py3k:
    import http.client as httplib
    import _thread as thread
    from urllib.parse import urljoin, SplitResult as UrlSplitResult
    from urllib.parse import urlencode, quote as urlquote, unquote as urlunquote
    urlunquote = functools.partial(urlunquote, encoding='latin1')
    from http.cookies import SimpleCookie
    from collections.abc import MutableMapping as DictMixin
    import pickle
    from io import BytesIO
    basestring = str
    unicode = str
    json_loads = lambda s: json_lds(touni(s))
    callable = lambda x: hasattr(x, '__call__')
    imap = map
else: # 2.x
    import httplib
    import thread
    from urlparse import urljoin, SplitResult as UrlSplitResult
    from urllib import urlencode, quote as urlquote, unquote as urlunquote
    from Cookie import SimpleCookie
    from itertools import imap
    import cPickle as pickle
    from StringIO import StringIO as BytesIO
    if py25:
        msg = "Python 2.5 support may be dropped in future versions of Bottle."
        warnings.warn(msg, DeprecationWarning)
        from UserDict import DictMixin
        def next(it): return it.next()
        bytes = str
    else: # 2.6, 2.7
        from collections import MutableMapping as DictMixin
    json_loads = json_lds

# Some helpers for string/byte handling
def tob(s, enc='utf8'):
    return s.encode(enc) if isinstance(s, unicode) else bytes(s)
def touni(s, enc='utf8', err='strict'):
    return s.decode(enc, err) if isinstance(s, bytes) else unicode(s)
tonat = touni if py3k else tob

# A bug in functools causes it to break if the wrapper is an instance method
def update_wrapper(wrapper, wrapped, *a, **ka):
    try: functools.update_wrapper(wrapper, wrapped, *a, **ka)
    except AttributeError: pass

# These helpers are used at module level and need to be defined first.
# And yes, I know PEP-8, but sometimes a lower-case classname makes more sense.

def depr(message):
    warnings.warn(message, DeprecationWarning, stacklevel=3)


class cached_property(object):
    ''' A property that is only computed once per instance and then replaces
        itself with an ordinary attribute. Deleting the attribute resets the
        property. '''

    def __init__(self, func):
        self.func = func

    def __get__(self, obj, cls):
        if obj is None: return self
        value = obj.__dict__[self.func.__name__] = self.func(obj)
        return value


class lazy_attribute(object):
    ''' A property that caches itself to the class object. '''
    def __init__(self, func):
        functools.update_wrapper(self, func, updated=[])
        self.getter = func

    def __get__(self, obj, cls):
        value = self.getter(cls)
        setattr(cls, self.__name__, value)
        return value






###############################################################################
# Exceptions and Events ########################################################
###############################################################################


class BottleException(Exception):
    """ A base class for exceptions used by bottle. """
    pass



###############################################################################
# HTTP Utilities and MISC (TODO) ###############################################
###############################################################################


def debug(mode=True):
    """ Change the debug level.
    There is only one debug level supported at the moment."""
    global DEBUG
    DEBUG = bool(mode)

def html_escape(string):
    ''' Escape HTML special characters ``&<>`` and quotes ``'"``. '''
    return string.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;')\
                 .replace('"','&quot;').replace("'",'&#039;')

def html_quote(string):
    ''' Escape and quote a string to be used as an HTTP attribute.'''
    return '"%s"' % html_escape(string).replace('\n','%#10;')\
                    .replace('\r','&#13;').replace('\t','&#9;')






###############################################################################
# Template Adapters ############################################################
###############################################################################


class TemplateError(BottleException):
    pass


class BaseTemplate(object):
    """ Base class and minimal API for template adapters """
    extensions = ['tpl','html','thtml','stpl']
    settings = {} #used in prepare()
    defaults = {} #used in render()

    def __init__(self, source=None, name=None, lookup=[], encoding='utf8', **settings):
        """ Create a new template.
        If the source parameter (str or buffer) is missing, the name argument
        is used to guess a template filename. Subclasses can assume that
        self.source and/or self.filename are set. Both are strings.
        The lookup, encoding and settings parameters are stored as instance
        variables.
        The lookup parameter stores a list containing directory paths.
        The encoding parameter should be used to decode byte strings or files.
        The settings parameter contains a dict for engine-specific settings.
        """
        self.name = name
        self.source = source.read() if hasattr(source, 'read') else source
        self.filename = source.filename if hasattr(source, 'filename') else None
        self.lookup = [os.path.abspath(x) for x in lookup]
        self.encoding = encoding
        self.settings = self.settings.copy() # Copy from class variable
        self.settings.update(settings) # Apply
        if not self.source and self.name:
            self.filename = self.search(self.name, self.lookup)
            if not self.filename:
                raise TemplateError('Template %s not found.' % repr(name))
        if not self.source and not self.filename:
            raise TemplateError('No template specified.')
        self.prepare(**self.settings)

    @classmethod
    def search(cls, name, lookup=[]):
        """ Search name in all directories specified in lookup.
        First without, then with common extensions. Return first hit. """
        if os.path.isfile(name): return name
        for spath in lookup:
            fname = os.path.join(spath, name)
            if os.path.isfile(fname):
                return fname
            for ext in cls.extensions:
                if os.path.isfile('%s.%s' % (fname, ext)):
                    return '%s.%s' % (fname, ext)

    @classmethod
    def global_config(cls, key, *args):
        ''' This reads or sets the global settings stored in class.settings. '''
        if args:
            cls.settings = cls.settings.copy() # Make settings local to class
            cls.settings[key] = args[0]
        else:
            return cls.settings[key]

    def prepare(self, **options):
        """ Run preparations (parsing, caching, ...).
        It should be possible to call this again to refresh a template or to
        update settings.
        """
        raise NotImplementedError

    def render(self, *args, **kwargs):
        """ Render the template with the specified local variables and return
        a single byte or unicode string. If it is a byte string, the encoding
        must match self.encoding. This method must be thread-safe!
        Local variables may be provided in dictionaries (*args)
        or directly, as keywords (**kwargs).
        """
        raise NotImplementedError


class MakoTemplate(BaseTemplate):
    def prepare(self, **options):
        from mako.template import Template
        from mako.lookup import TemplateLookup
        options.update({'input_encoding':self.encoding})
        options.setdefault('format_exceptions', bool(DEBUG))
        lookup = TemplateLookup(directories=self.lookup, **options)
        if self.source:
            self.tpl = Template(self.source, lookup=lookup, **options)
        else:
            self.tpl = Template(uri=self.name, filename=self.filename, lookup=lookup, **options)

    def render(self, *args, **kwargs):
        for dictarg in args: kwargs.update(dictarg)
        _defaults = self.defaults.copy()
        _defaults.update(kwargs)
        return self.tpl.render(**_defaults)


class CheetahTemplate(BaseTemplate):
    def prepare(self, **options):
        from Cheetah.Template import Template
        self.context = threading.local()
        self.context.vars = {}
        options['searchList'] = [self.context.vars]
        if self.source:
            self.tpl = Template(source=self.source, **options)
        else:
            self.tpl = Template(file=self.filename, **options)

    def render(self, *args, **kwargs):
        for dictarg in args: kwargs.update(dictarg)
        self.context.vars.update(self.defaults)
        self.context.vars.update(kwargs)
        out = str(self.tpl)
        self.context.vars.clear()
        return out


class Jinja2Template(BaseTemplate):
    def prepare(self, filters=None, tests=None, **kwargs):
        from jinja2 import Environment, FunctionLoader
        if 'prefix' in kwargs: # TODO: to be removed after a while
            raise RuntimeError('The keyword argument `prefix` has been removed. '
                'Use the full jinja2 environment name line_statement_prefix instead.')
        self.env = Environment(loader=FunctionLoader(self.loader), **kwargs)
        if filters: self.env.filters.update(filters)
        if tests: self.env.tests.update(tests)
        if self.source:
            self.tpl = self.env.from_string(self.source)
        else:
            self.tpl = self.env.get_template(self.filename)

    def render(self, *args, **kwargs):
        for dictarg in args: kwargs.update(dictarg)
        _defaults = self.defaults.copy()
        _defaults.update(kwargs)
        return self.tpl.render(**_defaults)

    def loader(self, name):
        fname = self.search(name, self.lookup)
        if not fname: return
        with open(fname, "rb") as f:
            return f.read().decode(self.encoding)


class SimpleTALTemplate(BaseTemplate):
    ''' Deprecated, do not use. '''
    def prepare(self, **options):
        depr('The SimpleTAL template handler is deprecated'\
             ' and will be removed in 0.12')
        from simpletal import simpleTAL
        if self.source:
            self.tpl = simpleTAL.compileHTMLTemplate(self.source)
        else:
            with open(self.filename, 'rb') as fp:
                self.tpl = simpleTAL.compileHTMLTemplate(tonat(fp.read()))

    def render(self, *args, **kwargs):
        from simpletal import simpleTALES
        for dictarg in args: kwargs.update(dictarg)
        context = simpleTALES.Context()
        for k,v in self.defaults.items():
            context.addGlobal(k, v)
        for k,v in kwargs.items():
            context.addGlobal(k, v)
        output = StringIO()
        self.tpl.expand(context, output)
        return output.getvalue()


class SimpleTemplate(BaseTemplate):
    blocks = ('if', 'elif', 'else', 'try', 'except', 'finally', 'for', 'while',
              'with', 'def', 'class')
    dedent_blocks = ('elif', 'else', 'except', 'finally')

    @lazy_attribute
    def re_pytokens(cls):
        ''' This matches comments and all kinds of quoted strings but does
            NOT match comments (#...) within quoted strings. (trust me) '''
        return re.compile(r'''
            (''(?!')|""(?!")|'{6}|"{6}    # Empty strings (all 4 types)
             |'(?:[^\\']|\\.)+?'          # Single quotes (')
             |"(?:[^\\"]|\\.)+?"          # Double quotes (")
             |'{3}(?:[^\\]|\\.|\n)+?'{3}  # Triple-quoted strings (')
             |"{3}(?:[^\\]|\\.|\n)+?"{3}  # Triple-quoted strings (")
             |\#.*                        # Comments
            )''', re.VERBOSE)

    def prepare(self, escape_func=html_escape, noescape=False, **kwargs):
        self.cache = {}
        enc = self.encoding
        self._str = lambda x: touni(x, enc)
        self._escape = lambda x: escape_func(touni(x, enc))
        if noescape:
            self._str, self._escape = self._escape, self._str

    @classmethod
    def split_comment(cls, code):
        """ Removes comments (#...) from python code. """
        if '#' not in code: return code
        #: Remove comments only (leave quoted strings as they are)
        subf = lambda m: '' if m.group(0)[0]=='#' else m.group(0)
        return re.sub(cls.re_pytokens, subf, code)

    @cached_property
    def co(self):
        return compile(self.code, self.filename or '<string>', 'exec')

    @cached_property
    def code(self):
        stack = [] # Current Code indentation
        lineno = 0 # Current line of code
        ptrbuffer = [] # Buffer for printable strings and token tuple instances
        codebuffer = [] # Buffer for generated python code
        multiline = dedent = oneline = False
        template = self.source or open(self.filename, 'rb').read()

        def yield_tokens(line):
            for i, part in enumerate(re.split(r'\{\{(.*?)\}\}', line)):
                if i % 2:
                    if part.startswith('!'): yield 'RAW', part[1:]
                    else: yield 'CMD', part
                else: yield 'TXT', part

        def flush(): # Flush the ptrbuffer
            if not ptrbuffer: return
            cline = ''
            for line in ptrbuffer:
                for token, value in line:
                    if token == 'TXT': cline += repr(value)
                    elif token == 'RAW': cline += '_str(%s)' % value
                    elif token == 'CMD': cline += '_escape(%s)' % value
                    cline +=  ', '
                cline = cline[:-2] + '\\\n'
            cline = cline[:-2]
            if cline[:-1].endswith('\\\\\\\\\\n'):
                cline = cline[:-7] + cline[-1] # 'nobr\\\\\n' --> 'nobr'
            cline = '_printlist([' + cline + '])'
            del ptrbuffer[:] # Do this before calling code() again
            code(cline)

        def code(stmt):
            for line in stmt.splitlines():
                codebuffer.append('  ' * len(stack) + line.strip())

        for line in template.splitlines(True):
            lineno += 1
            line = touni(line, self.encoding)
            sline = line.lstrip()
            if lineno <= 2:
                m = re.match(r"%\s*#.*coding[:=]\s*([-\w.]+)", sline)
                if m: self.encoding = m.group(1)
                if m: line = line.replace('coding','coding (removed)')
            if sline and sline[0] == '%' and sline[:2] != '%%':
                line = line.split('%',1)[1].lstrip() # Full line following the %
                cline = self.split_comment(line).strip()
                cmd = re.split(r'[^a-zA-Z0-9_]', cline)[0]
                flush() # You are actually reading this? Good luck, it's a mess :)
                if cmd in self.blocks or multiline:
                    cmd = multiline or cmd
                    dedent = cmd in self.dedent_blocks # "else:"
                    if dedent and not oneline and not multiline:
                        cmd = stack.pop()
                    code(line)
                    oneline = not cline.endswith(':') # "if 1: pass"
                    multiline = cmd if cline.endswith('\\') else False
                    if not oneline and not multiline:
                        stack.append(cmd)
                elif cmd == 'end' and stack:
                    code('#end(%s) %s' % (stack.pop(), line.strip()[3:]))
                elif cmd == 'include':
                    p = cline.split(None, 2)[1:]
                    if len(p) == 2:
                        code("_=_include(%s, _stdout, %s)" % (repr(p[0]), p[1]))
                    elif p:
                        code("_=_include(%s, _stdout)" % repr(p[0]))
                    else: # Empty %include -> reverse of %rebase
                        code("_printlist(_base)")
                elif cmd == 'rebase':
                    p = cline.split(None, 2)[1:]
                    if len(p) == 2:
                        code("globals()['_rebase']=(%s, dict(%s))" % (repr(p[0]), p[1]))
                    elif p:
                        code("globals()['_rebase']=(%s, {})" % repr(p[0]))
                else:
                    code(line)
            else: # Line starting with text (not '%') or '%%' (escaped)
                if line.strip().startswith('%%'):
                    line = line.replace('%%', '%', 1)
                ptrbuffer.append(yield_tokens(line))
        flush()
        return '\n'.join(codebuffer) + '\n'

    def subtemplate(self, _name, _stdout, *args, **kwargs):
        for dictarg in args: kwargs.update(dictarg)
        if _name not in self.cache:
            self.cache[_name] = self.__class__(name=_name, lookup=self.lookup)
        return self.cache[_name].execute(_stdout, kwargs)

    def execute(self, _stdout, *args, **kwargs):
        for dictarg in args: kwargs.update(dictarg)
        env = self.defaults.copy()
        env.update({'_stdout': _stdout, '_printlist': _stdout.extend,
               '_include': self.subtemplate, '_str': self._str,
               '_escape': self._escape, 'get': env.get,
               'setdefault': env.setdefault, 'defined': env.__contains__})
        env.update(kwargs)
        eval(self.co, env)
        if '_rebase' in env:
            subtpl, rargs = env['_rebase']
            rargs['_base'] = _stdout[:] #copy stdout
            del _stdout[:] # clear stdout
            return self.subtemplate(subtpl,_stdout,rargs)
        return env

    def render(self, *args, **kwargs):
        """ Render the template using keyword arguments as local variables. """
        for dictarg in args: kwargs.update(dictarg)
        stdout = []
        self.execute(stdout, kwargs)
        return ''.join(stdout)


def template(*args, **kwargs):
    '''
    Get a rendered template as a string iterator.
    You can use a name, a filename or a template string as first parameter.
    Template rendering arguments can be passed as dictionaries
    or directly (as keyword arguments).
    '''
    tpl = args[0] if args else None
    adapter = kwargs.pop('template_adapter', SimpleTemplate)
    lookup = kwargs.pop('template_lookup', TEMPLATE_PATH)
    tplid = (id(lookup), tpl)
    if tpl not in TEMPLATES or DEBUG:
        settings = kwargs.pop('template_settings', {})
        if isinstance(tpl, adapter):
            TEMPLATES[tplid] = tpl
            if settings: TEMPLATES[tplid].prepare(**settings)
        elif "\n" in tpl or "{" in tpl or "%" in tpl or '$' in tpl:
            TEMPLATES[tplid] = adapter(source=tpl, lookup=lookup, **settings)
        else:
            TEMPLATES[tplid] = adapter(name=tpl, lookup=lookup, **settings)
    if not TEMPLATES[tplid]:
        abort(500, 'Template (%s) not found' % tpl)
    for dictarg in args[1:]: kwargs.update(dictarg)
    return TEMPLATES[tplid].render(kwargs)

mako_template = functools.partial(template, template_adapter=MakoTemplate)
cheetah_template = functools.partial(template, template_adapter=CheetahTemplate)
jinja2_template = functools.partial(template, template_adapter=Jinja2Template)
simpletal_template = functools.partial(template, template_adapter=SimpleTALTemplate)



###############################################################################
# Constants and Globals ########################################################
###############################################################################


TEMPLATE_PATH = ['./',]
TEMPLATES = {}


# THE END
