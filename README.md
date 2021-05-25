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

### Initializing pyenv (Linux/Mac)

```console
$ git clone https://github.com/pyenv/pyenv.git ~/.pyenv
$ git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
$ git clone https://github.com/pyenv/pyenv-update.git ~/.pyenv/plugins/pyenv-update
```

**`.profile`** or **`.zshrc_local`**:
```sh
# pyenv setup
if [ -z "$PYENV_ROOT" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
```

When building Python with pyenv on macOS, `lzma` module may not be properly built.
Set the following environment variables:
```console
$ source pyenv-build-flags-homebrew.sh
```

### Initializing Kryptonite

```console
$ curl https://krypt.co/kr | sh
$ kr pair
```

**`.profile`** or **`.zshrc_local`**:
```sh
# kryptonite
if [[ ! `pgrep krd` ]]; then
  kr restart
fi
```

### Deploying the static configurations

```console
$ ./deply.py --flavor home
```

If any file already exists, it will ask you whether to overwrite it.
To overwrite always, add `--force`.

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

### Installing the latest mobile-shell (mosh)

```console
$ git clone https://github.com/mobile-shell/mosh
$ cd mosh
$ brew install automake
$ ./autogen.sh
$ ./configure --prefix=/usr/local
$ make && sudo make install
```

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
