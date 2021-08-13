#! /bin/bash

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
python deploy.py -f work --force
./gen-italics-terminfo.sh
vim +PluginInstall +qall