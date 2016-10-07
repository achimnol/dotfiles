# achimnol's dot files

## Overview

These are NOT just a set of static dotfiles.  
It has a deployment script (`deploy.py`) that generates configurations for different OS platforms (e.g., Windows, Linux, and Mac) using a "flavor" (e.g., home, work).
The script uses the template engine and [its simple syntax](http://bottlepy.org/docs/dev/stpl.html) from [bottle.py](http://bottlepy.org/docs/dev/index.html) (which is chosen because it is a single-file and self-contained), so you can use conditionals when writing templates (e.g., [vimrc](https://github.com/achimnol/dotfiles/blob/master/vimrc)).

## Configuration

Of course, this repository contains my *personal* settings.
After forking this repository, you need to customize `configuration.json`, in particular, **variables** section in flavor settings to change gitconfig user name and emails.

## Installation

### Initializing oh-my-zsh (when using zsh, for Linux/Mac only)

```
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
```
or
```
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
```

### Deploying the configurations

```
./deply.py --flavor home
```

If any file already exists, it will ask you whether to overwrite it.
To overwrite always, add `--force`.

### Initializing Vim Vundle

This repository does not include [Vundle](https://github.com/gmarik/Vundle.vim) and other vim plugins.
For the first time after running `deploy.py`, you must run the followings to get vim to work properly.

On Linux and Mac,
```
$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
$ vim +PluginInstall +qall
```

On Windows,
```
> git clone https://github.com/gmarik/Vundle.vim.git %USERPROFILE%/vimfiles/bundle/Vundle.vim
```
Run gVim and execute `:PluginInstall`.

If your user name contains non-ASCII characters, make a ASCII symbolic link of your `%USERPROFILE%` directoy as follows:
```
> mklink /d ASCIINAME NONASCIINAME
> set USERPROFILE=C:\Users\ASCIINAME
> set HOMEPATH=\Users\ASCIINAME
> "C:\Program Files (x86)\Vim\vim74\gvim.exe"
```
and then run `:PluginInstall`.

### Enabling italics support in terminals (for Linux/Mac only)

```
./gen-italics-terminfo.sh
```

### Workarounding user font recognition and system clipboard access issues in tmux on macOS

```
brew install tmux reattach-to-user-namespace
```

Set your iTerm profile's startup command to use `reattach-to-user-namespace -l zsh`. 
(Replace zsh with your favorite shell.)
