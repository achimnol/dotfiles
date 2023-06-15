#! /bin/bash

echo "===> Building latest mosh"
git clone --branch 'mosh-1.4.0' https://github.com/mobile-shell/mosh /tmp/mosh
cd /tmp/mosh
sudo apt install -y libprotobuf-dev protobuf-compiler
./autogen.sh
./configure --prefix=/usr/local
make && sudo make install
cd
rm -rf /tmp/mosh
