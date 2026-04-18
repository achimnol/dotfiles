# achimnol's dot files

## Overview

This is Joongi's semi-automated dotfiles distribution.

It has a deployment script (`deploy.py`) that generates configurations for different OS platforms (e.g., Windows, Linux, and Mac) using a "flavor" (e.g., home, work).
The script uses the template engine and [its simple syntax](http://bottlepy.org/docs/dev/stpl.html) from [bottle.py](http://bottlepy.org/docs/dev/index.html) (which is chosen because it is a single-file and self-contained), so you can use conditionals when writing templates (e.g., [vimrc](https://github.com/achimnol/dotfiles/blob/master/vimrc)).

## Configuration

Of course, this repository contains my *personal* settings.
After forking this repository, you need to customize `configuration.json`, in particular, **variables** section in flavor settings to change gitconfig user name and emails.

## Installation

### System Packages (Linux-Ubuntu)

```shell
sudo apt install build-essential pkg-config autoconf automake git-core tmux htop vim
sudo apt install libssl-dev libreadline-dev libgdbm-dev zlib1g-dev libbz2-dev liblzma-dev libsqlite3-dev libffi-dev
sudo apt install hexyl bat  # modern cli utils (Ubuntu 19.10+)
```

Some network debugging utilities:
```shell
sudo apt install dnsutils iproute2
```

### System Packages (macOS with Homebrew)

```shell
xcode-select --install
brew install git tmux htop python3
brew install macvim --with-override-system-vim --without-python --with-python3
brew install ncurses  # for gen-italics-terminfo.sh
brew install openssl sqlite3 readline zlib xz gdbm tcl-tk
brew install exa fd hexyl bat  # modern cli utils
```

Some network debugging utilities:
```shell
brew install iproute2mac
```

### Installing starship prompt

Starship must be installed separately before deploying dotfiles.
It provides the shell prompt (replaces the old oh-my-zsh achimnol theme).

macOS (Homebrew):
```shell
brew install starship
```

Linux (binary install to `/usr/local/bin`):
```shell
curl -sS https://starship.rs/install.sh | sh
```

To verify:
```shell
starship --version
```

### Initializing pyenv (Linux/Mac)

```shell
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-update.git ~/.pyenv/plugins/pyenv-update
```

#### pyenv 2.0+
**`.zprofile`** and **`.profile`** (depending on the content of `.profile`, you may symlink `.zprofile` to `.profile`)
```sh
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
```

**`.zshrc_local`**
```sh
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

### Installing lsd (ls replacement)

[Visit the official repo](https://github.com/lsd-rs/lsd/releases) and download/install the lsd-musl deb package.

### Deploying the static configurations

```shell
./deploy.py --flavor home --skip-scripts
```

If any file already exists, it will ask you whether to overwrite it.
To overwrite always, add `--force`.

### NeoVim

#### Installing NeoVim on Linux arm64/aarch64

Use linuxbrew when possible.

Many NeoVim plugins require luajit instead of Lua 5.1 to work properly.
We can install NeoVim using Snap (`sudo snap install nvim --classic`) but this version is built with Lua 5.1
and plugins like Telescope breaks.

To build NeoVim by yourself, install a few prerequisite and make it from source.
[Check out the official build instructions.](https://github.com/neovim/neovim/blob/master/BUILD.md)

#### Setting NeoVim as the default editor/vi

To let NeoVim serve the default `vi` command on Ubuntu-like distributions,
first put the following script as `/usr/local/bin/nvim` *if installed via Snap*:
```bash
#! /bin/bash
/usr/bin/snap run nvim "$@"
```
If you have built and installed NeoVim by yourself, `/usr/local/bin/nvim` is already the actual executable.

Then, execute this following command:
```shell
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 50
sudo update-alternatives --config editor
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 50
sudo update-alternatives --config vi
```

#### Initializing NeoVim

When NeoVim is executed for the first time, it will automatically install and load plugins via Lazy.

Install the CoC and treesitter plugins after initialization CoC itself.
```
:CocInstall coc-pyright coc-rust-analyzer coc-highlight
```

#### Sample configuration for a local `coc-settings.json`

```json
{
  "python.formatting.provider": "ruff",
  "python.linting.mypyEnabled": true,
  "python.linting.ruffEnabled": true,
  "coc.preferences.formatOnSaveFiletypes": ["python"],
  "python.pythonPath": "dist/export/python/virtualenvs/python-default/3.11.6/bin/python3"
}
```

### NodeJS for NeoVim CoC and npm packages

To install NodeJS as distro-specific packages, follow the instructions from [the nodesource distribution repository](https://github.com/nodesource/distributions).

To install multiple versions of NodeJS, use [the node version manager](http://github.com/nvm-sh/nvm).

### Enabling italics support in terminals (for Linux/Mac only)

To check if the italic font rednering works in your terminal, try:
```shell
echo -e "\e[3mfoo\e[23m"
```

If the above test command does NOT display an italic text, run:
```shell
./gen-italics-terminfo.sh
```

[A good guide is here.](https://www.reddit.com/r/vim/comments/24g8r8/italics_in_terminal_vim_and_tmux/)

### Loading the Git signing key into ssh-agent on macOS

The Git signing key (`~/.ssh/git-sign`) is not used for SSH connections, so `AddKeysToAgent`/`UseKeychain` in `~/.ssh/config` won't load it automatically. Register it with the Keychain explicitly (one-time):
```shell
ssh-add --apple-use-keychain ~/.ssh/git-sign
```

Then add the following to `.zprofile` to load all Keychain-stored keys into the agent on login:
```zsh
if [[ -z "$TMUX" ]]; then
  export SSH_AUTH_SOCK="$(launchctl getenv SSH_AUTH_SOCK)"
  ssh-add --apple-load-keychain 2>/dev/null
fi
```

### Installing the GitHub CLI (Ubuntu/Debian Linux)

```shell
./scripts/install-gh.sh
```

```shell
gh auth login
gh extension install seachicken/gh-poi  # extension to clean up local branches
```

### Installing the latest mobile-shell (mosh) (Optional)

```shell
./scripts/install-mosh.sh
```

### SSH_AUTH_SOCK propagation inside tmux on macOS

The macOS ssh-agent socket path (`/var/run/com.apple.launchd.<random>/Listeners`) changes on every reboot. To properly propagate `SSH_AUTH_SOCK` into tmux sessions, two conditions must be met:

1. **tmux.conf**: `update-environment` must include `SSH_AUTH_SOCK` (do not use the `-r` flag as it clears the entire list).
   ```tmux
   set-option -g update-environment "DISPLAY SSH_AUTH_SOCK SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY"
   ```

2. **Shell profile (`.zprofile`, etc.)**: If you use `launchctl getenv SSH_AUTH_SOCK` to obtain the socket path, it may return an empty value inside tmux and overwrite the value propagated by tmux. Guard it so it only runs outside of tmux.
   ```zsh
   if [[ -z "$TMUX" ]]; then
     export SSH_AUTH_SOCK="$(launchctl getenv SSH_AUTH_SOCK)"
   fi
   ```

### Enabling macOS key repeats

Run the following in the terminal and restart any apps to apply:
```shell
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Making macOS key repeat faster

Run the followings in the terminal and logout/login again.
```shell
defaults write -g InitialKeyRepeat -int 10  # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1          # normal minimum is 2 (30 ms)
```

### SSH agent forwarding fix for persistent tmux sessions on remote Linux hosts

When connecting to a remote Linux host from macOS,
the SSH agent forwarding socket (`SSH_AUTH_SOCK`) becomes stale
if the client disconnects (e.g., due to sleep) while a tmux session persists.
Build and install [ssh-agent-switcher](https://github.com/jmmv/ssh-agent-switcher)
on the remote host to automatically detect and switch to a working forwarded agent socket.

### WSL Setup

* `/mnt/c/Users/joongi/.wslconfig`:
```dosini
[wsl2]
networkingMode=mirrored
vmIdleTimeout=-1

[experimental]
hostAddressLoopback=true
```

* `/etc/wsl.conf`:
```dosini
[boot]
systemd=true
command="nohup dbus-launch true >/dev/null 2>&1 &"

[user]
default=joongi
```

> [!TIP]
> To keep the VM running after closing all terminals in the Windows host, run `dbus-launch true`.

To allow external SSH access (e.g., via VPN), we need to set the Windows & HyperV firewall rules:
```powershell
New-NetFirewallRule -DisplayName "Allow WSL SSH (Windows)" -Enabled True -Direction Inbound -Protocol TCP -LocalPort <SSHPORT> -Action Allow
New-NetFirewallHyperVRule -DisplayName "Allow WSL SSH (HyperV)" -Direction Inbound -LocalPorts <SSHPORT> -Action Allow
```

---

## Archived instructions (not used currently)

### Serena MCP configuration

After installing `uv` (and `uvx`), run:

```shell
serena config edit
```

and set `dashboard = false`.

### Initializing Vim Vundle

This repository does not include [Vundle](https://github.com/gmarik/Vundle.vim) and other vim plugins.
For the first time after running `deploy.py`, you must run the followings to get vim to work properly.

On Linux and Mac,
```console
$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
$ vim +PluginInstall +qall
```

On Windows,
```console
> git clone https://github.com/gmarik/Vundle.vim.git %USERPROFILE%/vimfiles/bundle/Vundle.vim
```
Run gVim and execute `:PluginInstall`.

If your user name contains non-ASCII characters, make a ASCII symbolic link of your `%USERPROFILE%` directoy as follows:
```console
> mklink /d ASCIINAME NONASCIINAME
> set USERPROFILE=C:\Users\ASCIINAME
> set HOMEPATH=\Users\ASCIINAME
> "C:\Program Files (x86)\Vim\vim74\gvim.exe"
```
and then run `:PluginInstall`.

### Initializing GnuPG (Linux)

**`.profile`** or **`.zshrc_local`**:
```sh
# gpg-agent setup
export GPG_TTY=`tty`
export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
gpgconf --launch gpg-agent
```

Note: Bash on Ubuntu reads `.profile` by default but ZSH does not.
In this case, add the following to `.zshrc_local`:

```sh
if [[ -o login ]]; then
    source $HOME/.profile
fi
```

Then, import the PGP key as you need.
