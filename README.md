# achimnol's dot files

## Overview

These are NOT just a set of static dotfiles.  
It has a deployment script (`deploy.py`) that generates configurations for different OS platforms (e.g., Windows, Linux, and Mac) using a "flavor" (e.g., home, work).
The script uses the template engine and [its simple syntax](http://bottlepy.org/docs/dev/stpl.html) from [bottle.py](http://bottlepy.org/docs/dev/index.html) (which is chosen because it is a single-file and self-contained), so you can use conditionals when writing templates (e.g., [vimrc](https://github.com/achimnol/dotfiles/blob/master/vimrc)).

## Configuration

Of course, this repository contains my *personal* settings.
After forking this repository, you need to customize `configuration.json`, in particular, **variables** section in flavor settings to change gitconfig user name and emails.

## Installation

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

### Enabling italics support in terminals (for Linux and Mac only)

```
./gen-italics-terminfo.sh
```
