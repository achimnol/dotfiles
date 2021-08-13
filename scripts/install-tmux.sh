#! /bin/bash

echo "===> Building latest tmux"
sudo apt install -y libevent-dev libncurses5-dev bison byacc
git clone https://github.com/tmux/tmux /tmp/tmux
cd /tmp/tmux
./autogen.sh
./configure --prefix=/usr/local
make && sudo make install
cd
rm -rf /tmp/tmux