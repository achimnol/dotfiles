#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# This script can run with Python 3.9 or higher.

# TODO List:
# - add extra handlers instead of just copying the template-generated files.
#   (e.g., executing the registry editor on .reg files)

from __future__ import print_function
import sys

# For compatibility
if sys.version_info < (3,0):
    print("Auto-configuration is not supported with Python 2.x")
    sys.exit(1)

import argparse
from functools import reduce
import subprocess
import os, sys, codecs, tempfile, shutil, stat
import json

from bottle_template import template

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

def populate_file(dotfile, flavor, args):
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
        if dotfile.get('template_vars', None) is not None:
            source = template(source, _platform=PLATFORM, **flavor['variables'])
        tmp_writer.write(source)

    skip = False
    progress_printed = False
    if os.path.isfile(dotfile['dest']):
        if merge_if_exists:
            print('  Merging with "{0}"...'.format(dotfile['dest']))
            progress_printed = True
        elif args.force:
            print('  Overwriting "{0}"...'.format(dotfile['dest']))
            progress_printed = True
        else:
            answer = simple_dialog('Do you want overwrite the existing file "{0}"?'.format(dotfile['dest']),
                                   ('y', 'n'), indent='  ')
            skip = (answer == 'n')

    if not skip and not args.dryrun:
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

def run_scripts(scripts, envs):
    for script in scripts:
        subprocess.run(script, env={**os.environ, **envs}, shell=True, check=True)


def get_platform():
    if os.environ.get("GITHUB_CODESPACE_TOKEN"):
        return "codespace"
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
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--flavor', dest='flavor', default='standard',
                        help='Specifies the flavor to replace template variables. (default: standard)')
    parser.add_argument('--force', dest='force', action='store_true', default=False,
                        help='Do not ask even if the target file already exists. This will overwrite everything without prompt. (default: no)')
    parser.add_argument('--skip-scripts', dest='skip_scripts', action='store_true', default=False,
                        help='Skip running the bootstrap scripts. (default: no)')
    parser.add_argument('-p', '--platform', dest='platform', default=None,
                        help='Override the platform. Use it only for testing. (default: None)')
    parser.add_argument('-y', '--dryrun', dest='dryrun', action='store_true', default=False,
                        help='Does not write anything but only show the running output. (default: no)')
    parser.add_argument('-b', '--base-path', dest='base_path', default=HOME_DIR,
                        help='Specifies the base directory. (default: your home directory)')
    parser.add_argument('config_files', metavar='FILES', nargs='*',
                        help='One or more config files to deploy. If prefixed with "@" it is interpreted as a config group name. (default: all compatible config files)')
    args = parser.parse_args()
    if args.platform:
        PLATFORM = args.platform
    if PLATFORM == 'others':
        print('The current system\'s platform is not supported.', file=sys.stderr)
        sys.exit(1)

    with open('configuration.json', 'r', encoding='utf8') as fp:
        conf = json.load(fp)

    # Validate options and configurations.
    if args.flavor not in conf['flavors']:
        print('No such flavor: "{0}".'.format(args.flavor), file=sys.stderr)
        sys.exit(1)
    base_flavor = conf['flavors']['_']
    concrete_flavor = conf['flavors'][args.flavor]
    flavor = {'variables': {}, 'excludes': [], 'scripts': []}
    for key, value in flavor.items():
        # Apply default values first and
        # update them with platform-specific values.
        if isinstance(value, dict):
            value.update(base_flavor['_'].get(key, {}))
            value.update(base_flavor[PLATFORM].get(key, {}))
            value.update(concrete_flavor['_'].get(key, {}))
            value.update(concrete_flavor[PLATFORM].get(key, {}))
        elif isinstance(value, list):
            value.extend(base_flavor['_'].get(key, []))
            value.extend(base_flavor[PLATFORM].get(key, []))
            value.extend(concrete_flavor['_'].get(key, []))
            value.extend(concrete_flavor[PLATFORM].get(key, []))
        else:
            raise NotImplementedError('Unsupported data type for value inheritance.')

    print('Detected platform: {0}'.format(PLATFORM))
    if args.dryrun:
        print('  << dry-run mode >>')
        args.skip_scripts = True

    dotfiles = []
    used_variables = set()
    active_dotfiles = {}

    # Calculate which dotfiles to populate.
    if len(args.config_files) == 0:
        active_dotfiles = {key: data for key, data in conf['dotfiles'].items()}
    else:
        for key, data in conf['dotfiles'].items():
            group = data.get('group', None)
            if group is not None and f"@{group}" in args.config_files:
                active_dotfiles[key] = data
            if data['source'] in args.config_files:
                active_dotfiles[key] = data
    # Filter out incompatible/excluded dotfiles
    for key, data in conf['dotfiles'].items():
        if PLATFORM not in data['compatible_platforms']:
            active_dotfiles.pop(key, None)
        if 'excludes' in flavor and key in flavor['excludes']:
            active_dotfiles.pop(key, None)

    for key, data in active_dotfiles.items():
        data = data.copy()
        assert os.path.isfile(data['source']), \
               'The source file "{0}" does not exist.'.format(data['source'])
        if 'platform_dependent_paths' in data:
            ppath = data['platform_dependent_paths'].get(PLATFORM, key)
            if isinstance(ppath, list) or isinstance(ppath, tuple):
                ppath = os.path.join(*(os.path.expandvars(p) for p in ppath))
        else:
            ppath = key
        ppath = ppath.replace('/', os.sep)
        data['dest'] = os.path.join(args.base_path, ppath)
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
            populate_file(dotfile, flavor, args)
    except (KeyboardInterrupt, EOFError):
        print('\nAborted.')

    if args.skip_scripts:
        print('Skipped running bootstrap scripts.')
    else:
        print('Running bootstrap scripts ...')
        run_scripts(flavor['scripts'], envs={
            'PLATFORM': PLATFORM,
        })

# vim: ft=python
