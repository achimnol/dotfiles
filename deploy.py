#!/usr/bin/env python
# -*- coding: utf-8 -*-
# This script can run with Python 2.6/2.7 and 3.0 or higher.

# TODO List:
# - add extra handlers instead of just copying the template-generated files.
#   (e.g., executing the registry editor on .reg files)

from __future__ import print_function
from functools import reduce
import os, sys, codecs, tempfile, shutil, stat
import json
from optparse import OptionParser
from bottle_template import template

# For compatibility
if sys.version_info < (3,0):
    input = raw_input
else:
    unicode = str

def simple_dialog(msg, answers, indent=''):
    list_of_answers = '[' + '/'.join(answers) + ']'
    answer = input(indent + msg + ' ' + list_of_answers + ': ').strip()
    while True:
        if answer in answers:
            return answer
        else:
            answer = input(indent + '  Please answer in one of ' + list_of_answers + ': ').strip()

def merge_json_files(json_files):
    data = []
    result = {}
    for fname in json_files:
        try:
            with open(fname, 'r') as f:
                data.append(json.load(f))
        except FileNotFoundError:
            pass
    for item in data:
        if not isinstance(item, dict):
            raise ValueError('Cannot merge non-object JSON data.')

    def merge_dict(src, update):
        result = {**src}
        for k, v in update.items():
            if isinstance(v, dict):
                if k in result:
                    result[k] = merge_dict(result[k], v)
                else:
                    result[k] = {**v}
            elif isinstance(v, list):
                if k in result:
                    result[k].extend(v)
                else:
                    result[k] = [*v]
            else:
                result[k] = v
        return result

    return reduce(merge_dict, data)

def populate_file(dotfile, flavor, opts):
    print('Generating "{0}"...'.format(dotfile['source']))
    tmp_path = None
    source = ''
    encoding = dotfile.get('encoding', 'utf8')
    merge_if_exists = dotfile.get('merge_if_exists', False)
    with codecs.open(dotfile['source'], 'r', encoding=encoding) as srcfile:
        source = srcfile.read()
    with tempfile.NamedTemporaryFile(prefix='dotfiles-', delete=False) as tmp:
        tmp_path = tmp.name
        EncodedWriter= codecs.getwriter(encoding)
        tmp_writer = EncodedWriter(tmp)
        if dotfile.get('template_vars', []):
            source = template(source, _platform=PLATFORM, **flavor['variables'])
        tmp_writer.write(source)

    skip = False
    progress_printed = False
    if os.path.isfile(dotfile['dest']):
        if merge_if_exists:
            print('  Merging with "{0}"...'.format(dotfile['dest']))
            progress_printed = True
        elif opts.force:
            print('  Overwriting "{0}"...'.format(dotfile['dest']))
            progress_printed = True
        else:
            answer = simple_dialog('Do you want overwrite the existing file "{0}"?'.format(dotfile['dest']),
                                   ('y', 'n'), indent='  ')
            skip = (answer == 'n')

    if not skip and not opts.dryrun:
        if not progress_printed:
            print('  Writing to "{0}"...'.format(dotfile['dest']))
        if not os.path.isdir(os.path.dirname(dotfile['dest'])):
            os.makedirs(os.path.dirname(dotfile['dest']))
        if merge_if_exists:
            if os.path.splitext(dotfile['dest'])[1] == '.json':
                with tempfile.NamedTemporaryFile(prefix='dotfiles.merge-') as merge_tmp:
                    EncodedWriter= codecs.getwriter(encoding)
                    merge_tmp_writer = EncodedWriter(merge_tmp)
                    merge_tmp_writer.write(
                        json.dumps(merge_json_files([dotfile['dest'], tmp_path]), indent=4)
                    )
                    merge_tmp_writer.flush()
                    shutil.copyfile(merge_tmp.name, dotfile['dest'])
            else:
                raise ValueError('Merging is only possible with json format.')
        else:
            shutil.copyfile(tmp_path, dotfile['dest'])
        if dotfile.get('executable', False):
            os.chmod(dotfile['dest'], stat.S_IRWXU | stat.S_IRGRP | stat.S_IXGRP | stat.S_IROTH)
    os.unlink(tmp_path)

def get_platform():
    if sys.platform.startswith('linux'):
        return 'linux'
    if sys.platform.startswith('win'):
        return 'windows'
    if sys.platform.startswith('darwin'):
        return 'mac'
    return 'others'


if __name__ == '__main__':
    # Determine the environment.
    HOME_DIR = os.path.expanduser('~')
    PLATFORM = get_platform()

    # Read options and configurations.
    oparser = OptionParser()
    oparser.add_option('-f', '--flavor', dest='flavor', type='string', default='standard',
                       help='Specifies the flavor to replace template variables. (default: standard)')
    oparser.add_option('--force', dest='force', action='store_true', default=False,
                       help='Do not ask even if the target file already exists. This will overwrite everything without prompt. (default: no)')
    oparser.add_option('-p', '--platform', dest='platform', default=None,
                       help='Override the platform. Use it only for testing. (default: None)')
    oparser.add_option('-y', '--dryrun', dest='dryrun', action='store_true', default=False,
                       help='Does not write anything but only show the running output. (default: no)')
    oparser.add_option('-b', '--base-path', dest='base_path', type='string', default=HOME_DIR,
                       help='Specifies the base directory. (default: your home directory)')
    opts, args = oparser.parse_args()
    if opts.platform:
        PLATFORM = opts.platform
    if PLATFORM == 'others':
        print('The current system\'s platform is not supported.', file=sys.stderr)
        sys.exit(1)

    with open('configuration.json', 'r') as fp:
        conf = json.load(fp, encoding='utf-8')

    # Validate options and configurations.
    if opts.flavor not in conf['flavors']:
        print('No such flavor: "{0}".'.format(opts.flavor), file=sys.stderr)
        sys.exit(1)
    raw_flavor = conf['flavors'][opts.flavor]
    flavor = {'variables': {}, 'excludes': []}
    for key in flavor.keys():
        # Apply default values first and
        # update them with platform-specific values.
        if isinstance(flavor[key], dict):
            flavor[key].update(raw_flavor['_'].get(key, {}))
            flavor[key].update(raw_flavor[PLATFORM].get(key, {}))
        elif isinstance(flavor[key], list):
            flavor[key].extend(raw_flavor['_'].get(key, []))
            flavor[key].extend(raw_flavor[PLATFORM].get(key, []))
        else:
            raise NotImplementedError('Unsupported data type for value inheritance.')

    print('Detected platform: {0}'.format(PLATFORM))
    if opts.dryrun:
        print('  << dry-run mode >>')

    dotfiles = []
    used_variables = set()

    for key, data in conf['dotfiles'].items():
        data = data.copy()
        if len(args) > 0 and data['source'] not in args:
            continue
        if PLATFORM not in data['compatible_platforms']:
            continue
        if 'excludes' in flavor and key in flavor['excludes']:
            continue
        assert os.path.isfile(data['source']), \
               'The source file "{0}" does not exist.'.format(data['source'])
        if 'platform_dependent_paths' in data:
            ppath = data['platform_dependent_paths'].get(PLATFORM, key)
            if isinstance(ppath, list) or isinstance(ppath, tuple):
                ppath = os.path.join(*(os.path.expandvars(p) for p in ppath))
        else:
            ppath = key
        ppath = ppath.replace('/', os.sep)
        data['dest'] = os.path.join(opts.base_path, ppath)
        dotfiles.append(data)
        if 'template_vars' in data:
            for var_name in data['template_vars']:
                used_variables.add(var_name)

    try:
        for var_name in used_variables:
            assert var_name in flavor['variables'], \
                   'Variable "{0}" is not defined.'.format(var_name)
    except AssertionError as e:
        print(e, file=sys.stderr)
        sys.exit(1)

    # At this point, we have valid data: dotfiles and flavor.

    try:
        for dotfile in dotfiles:
            populate_file(dotfile, flavor, opts)
    except (KeyboardInterrupt, EOFError):
        print('\nAborted.')

# vim: ft=python
