#! /bin/bash
# To use italics in "normal" terminals and tmux.
# From tmux's FAQ section: https://github.com/ThomasAdam/tmux/blob/master/FAQ

terms=( screen-256color xterm-256color )
for term in "${terms[@]}"; do
    infocmp "$term" > $term.terminfo.bak  # backup existing terminfo
    infocmp "$term" | sed \
      -e 's/%?%p1%t;3%/%?%p1%t;7%/' \
      -e 's/smso=[^,]*,/smso=\\E[7m,/' \
      -e 's/rmso=[^,]*,/rmso=\\E[27m,/' \
      -e '$s/$/ sitm=\\E[3m, ritm=\\E[23m,/' > /tmp/screen.terminfo
    tic /tmp/screen.terminfo
    rm /tmp/screen.terminfo
done
