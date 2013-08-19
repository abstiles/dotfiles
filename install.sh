#!/usr/bin/env bash
#
# Git likes to check out files with Windows-style line-endings, which makes
# things awkward. This line converts this script for execution in bash.
[ -z "$LF_EOL" ] && LF_EOL=1 exec -a $0 bash -s "$@" < <(dos2unix < $0) #

# Create essential global variables (if not already set).
[ -z "$WINUSER" ] && WINUSER=$(basename $(whoami) | sed 's/\r*$//')
[ -z "$WINHOME" ] && WINHOME=/cygdrive/c/Users/$WINUSER
MYDIR=`dirname $0`
STATIC_FILES=

usage () { cat << EOF
Usage:
	$0 { --help | -h }
	$0 [file glob(s)]

This script creates a symlink in the appropriate HOME directory for each file
in its local directory or for only those files that match the optional file
glob(s) passed into this script. Note that \$HOME is expected to be Cygwin's
\$HOME on Windows.
EOF
}

# Helper function to detect whether a file is Windows formatted.
is_dos() {
	path=$1
	# The logic here is to first check to ensure that the file is some kind of
	# text file. Then, if it is, check to see whether the "file" command reports
	# that the file has CRLF line-endings. Apprently, it's not guaranteed to do
	# this portably, so it falls back on using grep to check for any \r\n.
	[[ $(file $path) == *text* ]] && \
		[[ $(file $path) == *CRLF* ]] || grep -q -U '$' "$path"
}

# Flexible install for cygwin.
install_as_cygwin_dotfile() {
	filename=$1
	ln -fs "$(readlink -f "$MYDIR/$filename")" "$HOME/.$filename"
	# Windows-formatted files need a Unix-formatted version.
	if is_dos "$MYDIR/$filename"; then
		dos2unix -q --replace-symlink "$HOME/.$filename"
		# Set the flag indicating some files are "static" and need special care
		# to keep them up-to-date.
		STATIC_FILES=1
	fi
}

# I'm not sure I like this way of customizing the installation of different
# files, but I haven't settled on anything that's clearly superior.
apply_rule() {
	filename=$1
	case "$filename" in
		vim) # Install for both Windows and Cygwin Vim
			# On Windows Vim, this is $WINHOME/vimfiles
			cmd /c "mklink /J $(cygpath -aw $WINHOME/vimfiles) \
				$(cygpath -aw $MYDIR/$filename)" >/dev/null
			# For Cygwin, this is just ~/.vim
			mkdir -p "$HOME/.vim"
		;;
		vimrc|gvimrc) # Install for both Windows and Cygwin Vim
			# On Windows Vim, this is $WINHOME/_vimrc, but a symlink just won't
			# work as expected here, so generate a _vimrc file that points to
			# the one we want to install.
			cat > "$WINHOME/_$filename" <<-EOF
				" This level of indirection is necessary because of the weird
				" way Windows behaves (or just the way gVim in Windows behaves)
				" with symlinks.
				source `cygpath -am "$MYDIR/$filename"`
				let \$MY${filename^^}="`cygpath -am "$MYDIR/$filename"`"
			EOF
			# For Cygwin, this is just ~/.(g)vimrc
			install_as_cygwin_dotfile "$filename"
		;;
		vim/*) # Skip
		;;
		*) # Default behaviors -- create dotdirectories and symlink dotfiles
			# If this file is a directory, create it and move on
			if [[ -d "$MYDIR/$filename" ]]; then
				mkdir -p "$HOME/.$filename"
				return
			fi
			# Create the enclosing directory if it doesn't exist
			if [[ ! -d "$HOME/.$(dirname "$filename")" ]]; then
				mkdir -p "$HOME/.$(dirname "$filename")"
			fi
			install_as_cygwin_dotfile "$filename"
		;;
	esac
}

files=()
for arg in "$@"; do
	if [[ $arg == --help || $arg == -h ]]; then
		usage
		exit
	fi
	files+=("$arg")
done

if [ -z "$*" ]; then files=('*'); fi

# Install all files and directories as dotfiles (and dotdirectories) in the
# home directory, except this install script. Dotfiles are also skipped.
while read FILE; do
	apply_rule "$FILE"
done < <(\
for item in "${files[@]}"; do
	/usr/bin/find $MYDIR ! -path "$MYDIR/.*" -path "$MYDIR/$item" | \
		grep -xv "$0" | grep -v '/\.' | \
		sed -e "s|^$MYDIR/||"
done)
# If the above looks like shenanigans to you, it's a contortion to ensure that
# the apply_rule function is executed in the same shell as the rest of the
# script. This is needed to check for static files. It's functionally same
# thing as the below:
#
#for item in "${files[@]}"; do
#	/usr/bin/find $MYDIR ! -path "$MYDIR/.*" -path "$MYDIR/$item" | \
#		grep -xv "$0" | grep -v '/\.' | \
#		sed -e "s|^$MYDIR/||" | \
#		while read FILE; do
#			apply_rule "$FILE"
#		done
#done

if [ -n "$STATIC_FILES" ]; then
	echo "WARNING: some files could not be symlinked and were simply copied."
	echo "Re-run this program when any files change in order to keep everything"
	echo "up-to-date."
fi
