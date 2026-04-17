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

# Terminal key bindings (previously handled by oh-my-zsh)
bindkey '^[[H'  beginning-of-line      # Home (xterm)
bindkey '^[[F'  end-of-line            # End (xterm)
bindkey '^[[1~' beginning-of-line      # Home (tmux/screen)
bindkey '^[[4~' end-of-line            # End (tmux/screen)
bindkey '^[[3~' delete-char            # Delete
bindkey '^[[1;5C' forward-word         # Ctrl+Right
bindkey '^[[1;5D' backward-word        # Ctrl+Left
bindkey '^[[1;3C' forward-word         # Alt+Right
bindkey '^[[1;3D' backward-word        # Alt+Left
bindkey '^H'    backward-delete-word   # Ctrl+Backspace

# --- Environment ---
export TTY=$(tty)
export SVN_EDITOR=vim
export HGENCODING=UTF-8
export HGEDITOR=~/hgeditor
export PAGER='less -RFX'
export GH_PAGER='less -RFX'

typeset -U PATH

# --- Hooks and version managers ---
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -f "$(which direnv)" ] && eval "$(direnv hook zsh)"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
export PYENV_ROOT="$HOME/.pyenv"
[ -d $PYENV_ROOT/bin ] && export PATH="$PYENV_ROOT/bin:$PATH"
[ -d $PYENV_ROOT/bin ] && eval "$(pyenv init - zsh)"
[ -s "$HOME/.gvm/scripts/gvm" ] && source "$HOME/.gvm/scripts/gvm"

# vim: sts=2 sw=2 et
