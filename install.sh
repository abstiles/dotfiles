#!/usr/bin/env bash
#
# Git likes to check out files with Windows-style line-endings, which makes
# things awkward. This line converts this script for execution in bash.
[ -z "$CRLF_CONVERTED" ] && CRLF_CONVERTED=1 exec bash <(dos2unix < $0)
export CRLF_CONVERTED=

usage () { cat << EOF
Usage:
	$0 { --help | -h }
	$0 [file glob(s)]

This script creates a symlink in \$HOME for each file in its local directory
or for only those files that match the optional file glob(s) passed into
this script.
EOF
}

# Sorry, this script is disabled for now.
cat << EOF
At no point was any of this designed with Windows in mind, therefore it's
completely broken. Symlinks seem to barely work in Windows... some things work
fine with them, and others don't. Also, the whole "dotfile" convention isn't
really meaningful in Windows, so there's that.

This script will need to be modified in order to allow easy configuration of
install rules for every file here. Symlinking dotfiles will probably work just
fine for things like bash, but e.g., Vim needs a weird level of indirection for
its vimrc since it doesn't behave well with a symlinked vimrc.

Aborting. Press any key to exit.
EOF
# Because Windows likes to close the console after script termination.
read
exit 1

# Equivalent to "readlink -f" on Linux, but cross-platform (for BSD)
get_real_path () {
	echo $(python -c 'import os, sys; print os.path.realpath(sys.argv[1])' "$1")
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

# Install all files and directories as dotfiles (and dotdirectories) in the
# home directory, except this install script.
for item in "${files[@]}"; do
	find $dir ! -path "$dir/.*" -path "$dir/$item" | \
		grep -xv "$0" | \
		sed -e "s|^$dir/||" | \
		while read FILE; do
			# If this path is a directory, create it and move on
			if [[ -d "$dir/$FILE" ]]; then
				mkdir -p "$HOME/.$FILE"
				continue
			fi
			# Create the enclosing directory if it doesn't exist
			# You'd think nested quotes like this wouldn't work, but it's the
			# only way to get the full path grouped correctly (that I can see).
			if [[ ! -d "$HOME/.$(dirname "$FILE")" ]]; then
				mkdir -p "$HOME/.$(dirname "$FILE")"
			fi
			ln -s "$(get_real_path "$dir/$FILE")" "$HOME/.$FILE"
		done
done
