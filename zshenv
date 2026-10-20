# Skip Ubuntu's global compinit in /etc/zsh/zshrc; ~/.zshrc runs compinit itself.
skip_global_compinit=1

# These are already present in .zshrc, but required for mosh login shells
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
