# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="achimnol"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git pyenv virtualenv svn mercurial)

# User configuration
# export PATH="/Users/daybreaker/.rvm/bin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin"
# export MANPATH="/usr/local/man:$MANPATH"
setopt no_share_history
if [ -f ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi

# Load oh-my-zsh!
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
#if [[ -n $SSH_CONNECTION ]]; then
#  export EDITOR='vim'
#else
  export EDITOR='vim'
#fi

# Prevent Ctrl+S from freezing terminal (which can be recovered with Ctrl+Q)
# to set other functions to these keys.
stty stop undef
stty start undef

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
  os_type=`uname -s`
  if [[ "$os_type" == "Linux" ]]; then
    LS_COLOR_OPTION='--color=auto'
  else
    LS_COLOR_OPTION='-G'
  fi
  # if [[ "$TERM" == "tmux-256color" ]]; then
  #   alias ls="TERM=xterm-256color ls $LS_COLOR_OPTION"
  #   alias dir="TERM=xterm-256color ls $LS_COLOR_OPTION"
  #   alias htop='TERM=xterm-color htop'
  # else
    alias ls="ls $LS_COLOR_OPTION"
    alias dir="ls $LS_COLOR_OPTION"
  # fi
fi
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias tmux='tmux -2'
alias make='make -j'
alias sudo='sudo '  # let aliases work with sudo

alias rg='rg --colors path:fg:green --colors path:style:bold --colors match:bg:yellow --colors match:fg:black --colors match:style:nobold --context-separator=---- '

# Fix tmux/screen home/end keys
if [[ "$TERM" =~ ^tmux || "$TERM" =~ ^screen ]]; then
    bindkey '^[[1~' beginning-of-line
    bindkey '^[[4~' end-of-line
fi

export TTY=$(tty)
export SVN_EDITOR=vim
export HGENCODING=UTF-8
export HGEDITOR=~/hgeditor

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
setopt no_share_history
unsetopt auto_cd

typeset -U PATH

if [ -f "$(which direnv)" ]; then
    eval "$(direnv hook zsh)"
fi

export PAGER='less -RFX'
export GH_PAGER='less -RFX'
