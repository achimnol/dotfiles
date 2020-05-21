# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
if [[ $(tty) = *pts* || $TERM_PROGRAM = 'Apple_Terminal' ]]; then
    case "$TERM" in
    linux|screen-256color|xterm-256color|screen-256color-italics|xterm-256color-italics)
	if [[ "$EUID" -eq 0 ]]; then
	    PS1='\[\033[38;5;211m\][\t] \[\033[38;5;198m\]${debian_chroot}\u\[\033[38;5;133m\]@\[\033[38;5;220m\]\h\[\033[38;5;162m\]:\[\033[38;5;210m\]\w\[\033[38;5;196m\]\$ \[\033[0m\]'
	else
	    PS1='\[\033[38;5;211m\][\t] \[\033[38;5;118m\]${debian_chroot}\u\[\033[38;5;69m\]@\[\033[38;5;220m\]\h\[\033[38;5;162m\]:\[\033[37;1m\]\w\$ \[\033[0m\]'
	fi
	;;
    xterm|xterm-color|screen)
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	;;
    *)
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	;;
    esac

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*|linux*)
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/'"'~'"'}\007"'
	;;
*)
	;;
    esac
else
    # Console terminals usually do not support 256 colors.
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Prevent Ctrl+S from freezing terminal (which can be recovered with Ctrl+Q)
# to set other functions to these keys.
stty stop undef
stty start undef

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    if [ `uname -s` == "Linux" ]; then
%if term_colorscheme == "solarized":
	eval "`TERM=screen-256color dircolors ~/.dircolors`"
%else:
	eval "`TERM=screen-256color dircolors -b`"
%end
	LS_COLOR_OPTION='--color=auto'
    else
	LS_COLOR_OPTION='-G'
    fi
    alias ls="ls $LS_COLOR_OPTION"
    alias dir="ls $LS_COLOR_OPTION"
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias tmux='tmux -2'
alias sfind='~/sfind.py'

alias rg='rg --colors path:fg:green --colors path:style:bold --colors match:bg:yellow --colors match:fg:black --colors match:style:nobold --context-separator=---- '

case `uname -s` in
    Linux)
	num_cpus=`cat /proc/cpuinfo|grep -c processor`
	alias make="make -j$num_cpus"
	alias snakemake="snakemake -j$num_cpus"
	;;
    Darwin)
	num_cpus=`sysctl hw.ncpu | cut -d" " -f 2`
	alias make="make -j$num_cpus"
	alias snakemake="snakemake -j$num_cpus"
	;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

export TTY=$(tty)
export SVN_EDITOR=vim
export HGENCODING=UTF-8
export HGEDITOR=~/hgeditor

# enable local modifications.
if [ -f ~/.bashrc_local ]; then
	. ~/.bashrc_local
fi

# macOS Catalina
export BASH_SILENCE_DEPRECATION_WARNING=1
