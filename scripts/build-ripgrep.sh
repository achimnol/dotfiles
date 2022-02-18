#! /bin/bash

git clone https://github.com/BurntSushi/ripgrep /tmp/ripgrep
cd /tmp/ripgrep
cargo build --release
sudo cp ./target/release/rg /usr/local/bin/rg
hash -r
cd $HOME
rm -rf /tmp/ripgrep
rg --version
