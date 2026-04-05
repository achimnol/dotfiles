# Zsh configuration (starship prompt)

# --- Completion ---
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt no_share_history

# --- Key bindings ---
# Use emacs keymap (Ctrl+R for reverse search, etc.)
# oh-my-zsh set this implicitly; needed now that we use starship directly.
bindkey -e

# --- Options ---
unsetopt auto_cd

# --- pyenv ---
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# --- Local config ---
if [ -f ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi

# --- Git email cache (updated on cd, read by starship env_var) ---
_update_git_email() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    export GIT_EMAIL=$(git config user.email)
  else
    unset GIT_EMAIL
  fi
}
_update_git_email  # initial shell
chpwd_functions+=(_update_git_email)

# --- Starship prompt ---
eval "$(starship init zsh)"

# Prevent Ctrl+S from freezing terminal (which can be recovered with Ctrl+Q)
stty stop undef
stty start undef

# --- Aliases ---
alias ls='lsd'
alias dir='lsd'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias tmux='tmux -2'
alias make='make -j'
alias sudo='sudo '  # let aliases work with sudo
alias serena='uvx --from git+https://github.com/oraios/serena serena'

alias rg='rg --colors path:fg:green --colors path:style:bold --colors match:bg:yellow --colors match:fg:black --colors match:style:nobold --context-separator=---- '

# Fix tmux/screen home/end keys
if [[ "$TERM" =~ ^tmux || "$TERM" =~ ^screen ]]; then
  bindkey '^[[1~' beginning-of-line
  bindkey '^[[4~' end-of-line
fi

# --- Environment ---
export TTY=$(tty)
export SVN_EDITOR=vim
export HGENCODING=UTF-8
export HGEDITOR=~/hgeditor

typeset -U PATH

if [ -f "$(which direnv)" ]; then
  eval "$(direnv hook zsh)"
fi

export PAGER='less -RFX'
export GH_PAGER='less -RFX'

# vim: sts=2 sw=2 et
