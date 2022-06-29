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
# To use italics in "normal" terminals and tmux.
# From tmux's FAQ section: https://github.com/ThomasAdam/tmux/blob/master/FAQ

# terms=( xterm-256color )
# for term in "${terms[@]}"; do
#     $INFOCMP "$term" > $term.terminfo.bak  # backup existing terminfo
#     $INFOCMP "$term" | sed \
#       -e 's/%?%p1%t;3%/%?%p1%t;7%/' \
#       -e 's/smso=[^,]*,/smso=\\E[7m,/' \
#       -e 's/rmso=[^,]*,/rmso=\\E[27m,/' \
#       -e '$s/$/ sitm=\\E[3m, ritm=\\E[23m,/' > /tmp/$term.terminfo
#     $TIC /tmp/$term.terminfo
#     rm /tmp/$term.terminfo
# done

# Combine xterm-256color and screen-256color to generate tmux-256color
$TIC -x ./tmux-256color.terminfo
