# To use italics in "normal" terminals and tmux.
# From tmux's FAQ section: https://github.com/ThomasAdam/tmux/blob/master/FAQ

screen_terminfo=screen-256color
infocmp "$screen_terminfo" | sed \
-e 's/^screen[^|]*|[^,]*,/screen-256color-italics|screen-256color with italics support,/' \
-e 's/%?%p1%t;3%/%?%p1%t;7%/' \
-e 's/smso=[^,]*,/smso=\\E[7m,/' \
-e 's/rmso=[^,]*,/rmso=\\E[27m,/' \
-e '$s/$/ sitm=\\E[3m, ritm=\\E[23m,/' > /tmp/screen.terminfo
tic /tmp/screen.terminfo
rm /tmp/screen.terminfo

screen_terminfo=xterm-256color
infocmp "$screen_terminfo" | sed \
-e 's/^xterm[^|]*|[^,]*,/xterm-256color-italics|xterm-256color with italics support,/' \
-e 's/%?%p1%t;3%/%?%p1%t;7%/' \
-e 's/smso=[^,]*,/smso=\\E[7m,/' \
-e 's/rmso=[^,]*,/rmso=\\E[27m,/' \
-e '$s/$/ sitm=\\E[3m, ritm=\\E[23m,/' > /tmp/screen.terminfo
tic /tmp/screen.terminfo
rm /tmp/screen.terminfo
