#! /bin/bash

python deploy.py -f work --force
./gen-italics-terminfo.sh
