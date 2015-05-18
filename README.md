# achimnol's dot files

## Overview

These are NOT just a set of static dotfiles.  
It has a deplyoment script (`deploy.py`) that generates configurations for different OS platforms (e.g., Windows, Linux, and Mac) using a "flavor" (e.g., home, work).
The script uses the template engine from [bottle.py](http://bottlepy.org/docs/dev/index.html) (which is chosen because it is a single-file and self-contained), so you can use conditionals when writing templates (e.g., vimrc).

## Configuration

Of course, this repository contains my *personal* settings.
After forking this repository, you need to customize `configuration.json`, in particular, variables section in flavor settings to change gitconfig user name and emails.

## Installation

'''
./deply.py --flavor home
'''

If any file already exists, it will ask you whether to overwrite it.
To overwrite always, add `--force`.

