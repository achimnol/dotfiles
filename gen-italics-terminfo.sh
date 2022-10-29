#! /bin/bash
set -e
INFOCMP="/usr/bin/infocmp"
TIC="/usr/bin/tic"

# The latest terminfo can be downloaded by:
# curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz
gunzip -c terminfo.src.gz > terminfo.src
echo "Using tic: $TIC"
$TIC -xe screen-256color terminfo.src
$TIC -xe tmux-256color terminfo.src
