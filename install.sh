#!/bin/bash

usage () { cat << EOF
Usage:
	$0 { --help | -h }
	$0 [file glob(s)]

This script creates a symlink in \$HOME for each file in its local directory
or for only those files that match the optional file glob(s) passed into
this script.
EOF
}

files=()
for arg in "$@"; do
	if [[ $arg == --help || $arg == -h ]]; then
		usage
		exit
	fi
	files+=("$arg")
done

dir=`dirname $0`

if [ -z "$*" ]; then files=('*'); fi

# Create all directories
for item in "${files[@]}"; do
	find $dir -type d ! -path "$dir/.*" -path "$dir/$item" -printf '%P\n' | \
		while read FILE; do
			mkdir -p "$HOME/.$FILE"
		done
done

# Install all non-shell-script files as dotfiles in the home directory.
for item in "${files[@]}"; do
	find $dir -type f ! -path "$dir/.*" -path "$dir/$item" -printf '%P\n' | \
		grep -xv '.*\.sh' | \
		while read FILE; do
			# You'd think nested quotes like this wouldn't work, but it's the
			# only way to get the full path grouped correctly (that I can see).
			ln -s "$(readlink -f "$dir/$FILE")" "$HOME/.$FILE"
		done
done
