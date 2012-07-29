#!/bin/bash

# Install all non-shell-script files as dotfiles in the home directory.
find `dirname $0` -type f ! -path `dirname $0`/'.*' -printf '%f\n' | \
	grep -xv '.*\.sh' | \
	while read FILE; do
		ln -s $(readlink -f `dirname $0`/$FILE) $HOME/.$FILE
	done
