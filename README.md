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

```console
$ sudo apt install build-essential pkg-config autoconf automake git-core tmux htop vim
$ sudo apt install gnupg-agent gnupg2
$ sudo apt install libssl-dev libreadline-dev libgdbm-dev zlib1g-dev libbz2-dev liblzma-dev libsqlite3-dev libffi-dev
$ sudo add-apt-repository ppa:jonathonf/vim
$ sudo apt update
$ sudo apt install vim
$ sudo apt install fd hexyl bat  # modern cli utils (Ubuntu 19.10+) / exa should be installed via Rust Cargo
```

For latest tmux (3.0+):
```
$ git clone https://github.com/tmux/tmux /tmp/tmux
$ cd /tmp/tmux
$ sudo apt install libevent-dev libncurses5-dev bison byacc
$ ./autogen.sh
$ ./configure --prefix=/usr/local && make && sudo make install
$ hash -r
```

For latest mosh:
```
$ git clone https://github.com/mobile-shell/mosh /tmp/mosh
$ cd /tmp/mosh
$ sudo apt install libprotobuf-dev protobuf-compiler
$ ./autogen.sh
$ ./configure --prefix=/usr/local && make && sudo make install
$ hash -r
```

Some network debugging utilities:
```console
$ sudo apt install dnsutils iproute2
```

### System Packages (macOS with Homebrew)

```console
$ xcode-select --install
$ brew install git tmux htop python3
$ brew install macvim --with-override-system-vim --without-python --with-python3
$ brew install gpg-agent
$ brew install ncurses  # for gen-italics-terminfo.sh
$ brew install openssl sqlite3 readline zlib xz gdbm tcl-tk
$ brew install exa fd hexyl bat  # modern cli utils
```

Some network debugging utilities:
```console
$ brew install iproute2mac
```

### Initializing oh-my-zsh (when using zsh, for Linux/Mac only)

```console
$ wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
```
or
```console
$ curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
```

### Initializing pyenv (Linux/Mac)

```console
$ git clone https://github.com/pyenv/pyenv.git ~/.pyenv
$ git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
$ git clone https://github.com/pyenv/pyenv-update.git ~/.pyenv/plugins/pyenv-update
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

#### extra for macOS

When building Python with pyenv on macOS, `lzma` module may not be properly built.
Set the following environment variables:
```console
$ source pyenv-build-flags-homebrew.sh
```

### Deploying the static configurations

```console
$ ./deploy.py --flavor home
```

If any file already exists, it will ask you whether to overwrite it.
To overwrite always, add `--force`.

### NeoVim on Linux arm64/aarch64

Many NeoVim plugins require luajit instead of Lua 5.1 to work properly.
We can install NeoVim using Snap (`sudo snap install nvim --classic`) but this version is built with Lua 5.1
and plugins like Telescope breaks.

To build NeoVim by yourself, install a few prerequisite and make it from source.
[Check out the official build instructions.](https://github.com/neovim/neovim/wiki/Building-NeoVim)

#### Setting NeoVim as the default editor/vi

To let NeoVim serve the default `vi` command on Ubuntu-like distributions,
first put the following script as `/usr/local/bin/nvim` *if installed via Snap*:
```bash
#! /bin/bash
/usr/bin/snap run nvim "$@"
```
If you have built and installed NeoVim by yourself, `/usr/local/bin/nvim` is already the actual executable.

Then, execute this following command:
```console
$ sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 50
$ sudo update-alternatives --config editor
$ sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 50
$ sudo update-alternatives --config vi
```

### Initializing NeoVim Plug

Follow the instructions from [the official GitHub README](https://github.com/junegunn/vim-plug).
```console
$ sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
>        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
$ nvim +PlugInstall
```

Also install the CoC and treesitter plugins after initialization CoC itself.
```
:CocInstall coc-pyright coc-rust-analyzer coc-highlight
```

### NodeJS for NeoVim CoC and npm packages

Follow the instructions from [the nodesource distribution repository](https://github.com/nodesource/distributions).

### Language Server configurations for Vim

Run `:LspInstallServer` after opening a source file in a project working directory.

### Enabling italics support in terminals (for Linux/Mac only)

```console
$ ./gen-italics-terminfo.sh
```

To check if the italic font rednering works in your terminal, try:
```console
$ echo -e "\e[3mfoo\e[23m"
```

[A good guide is here.](https://www.reddit.com/r/vim/comments/24g8r8/italics_in_terminal_vim_and_tmux/)

### Setting up Git commit signing with the SSH keypair

```console
$ git config --global user.signingkey ~/.ssh/id_rsa
```

### Installing the GitHub CLI (Ubuntu/Debian Linux)

```shell
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

```console
$ gh auth login
$ gh extension install seachicken/gh-poi  # extension to clean up local branches
```

### Installing the latest mobile-shell (mosh) (Optional)

```console
$ git clone https://github.com/mobile-shell/mosh
$ cd mosh
$ brew install automake
$ ./autogen.sh
$ ./configure --prefix=/usr/local
$ make && sudo make install
```

### Workarounding user font recognition and system clipboard access issues in tmux on macOS

```console
$ brew install tmux reattach-to-user-namespace
```

Set your iTerm profile's startup command to use `reattach-to-user-namespace -l zsh`.
(Replace zsh with your favorite shell.)

### Enabling macOS key repeats

Run the following in the terminal and restart any apps to apply:
```console
$ defaults write -g ApplePressAndHoldEnabled -bool false
```

### Making macOS key repeat faster

Run the followings in the terminal and logout/login again.
```console
$ defaults write -g InitialKeyRepeat -int 10  # normal minimum is 15 (225 ms)
$ defaults write -g KeyRepeat -int 1          # normal minimum is 2 (30 ms)
```



## Archived instructions (not used currently)

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
