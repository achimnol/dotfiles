#! /usr/bin/python

import sys, os

ignore_list = [ # from ack-grep --help
    'autom4te.cache',
    'blib',
    '_build',
    '.bzr',
    '.cdv',
    'cover_db',
    'CVS',
    '_darcs',
    '~.dep',
    '~.dot',
    '.git',
    '.hg',
    '~.nib',
    '.pc',
    '~.plst',
    'RCS',
    'SCCS',
    '_sgbak',
    '.svn',
]

if __name__ == '__main__':
    # A simple automaton to match original find command:
    #   state 0: accepts find options
    #   state 1: accepts pathname
    #   state 2: accepts condition/action expressions
    args = ['find']
    state = 0
    for arg in sys.argv[1:]:
        if state == 0:
            if arg.startswith('-'):
                assert arg[1] in ('H', 'D', 'L', 'P')
                args.append(arg)
            else:
                args.append(arg)
                state = 1
        elif state == 1:
            if arg.startswith('-'):
                # Insert the prune condition at the beginning of
                # condition/action expression.
                args.append('! \\( \\(')
                temp = []
                for item in ignore_list:
                    temp.append('-wholename \'*/%s*\'' % item)
                args.append(' -o '.join(temp))
                args.append('\\) -prune \\)')
                args.append(arg)
                state = 2
            else:
                args.append(arg)
        elif state == 2:
            if not arg.startswith('-'):
                arg = '\'%s\'' % arg
            args.append(arg)
    os.system(' '.join(args))
