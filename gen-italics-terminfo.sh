#! /bin/bash
set -e
if [[ `uname -s` == "Darwin" ]]; then
  INFOCMP="/opt/homebrew/Cellar/ncurses/6.3/bin/infocmp"
  TIC="/opt/homebrew/Cellar/ncurses/6.3/bin/tic"
  if [[ ! -f $INFOCMP ]]; then
    echo "Install ncurses via homebrew and check its version in /usr/local/Cellar/ncurses."
    exit 1
  fi
else
  INFOCMP="infocmp"
  TIC="tic"
fi

# The latest terminfo can be downloaded by:
# curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz

gunzip -c terminfo.src.gz > terminfo.src
# $TIC -xe screen-256color terminfo/terminfo.src
$TIC -xe tmux-256color terminfo.src

## # Patch xterm-256color in place
## $INFOCMP xterm-256color | python patch-italics-terminfo.py > ./xterm-256color-patched.terminfo
## $TIC -x ./xterm-256color-patched.terminfo
## rm ./xterm-256color-patched.terminfo
## 
## # Combine xterm-256color and screen-256color to generate tmux-256color
## $TIC -x ./tmux-256color.terminfo
