#!/bin/bash

alias tclsh='rlwrap tclsh'
if [[ $(uname) == Linux ]]; then
	alias ls='ls --color=auto'
	alias l='/bin/ls --color=never -CF'
	alias la='ls -A'
	unalias ll &>/dev/null
	function ll () { ls --color=always -hAlF "$@" | less -FR; }
	alias grep='grep --color=auto'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'
else
	alias ls='ls -G'
fi
alias view='vim -R'
alias su="su -m"
alias copy="xclip -selection CLIPBOARD"
alias vitodo="vim ~/.todo/list.txt"
alias info="info --vi-keys"
alias df="df -Ph | sed 's/Mounted on/Mounted_on/' | column -t | sed 's/Mounted_on/Mounted on/'"

alias browser='if [[ -z "$BROWSER" ]]; then echo "Environment variable \$BROWSER not set!"; else ($BROWSER &>/dev/null &); fi'

function cd () {
	if [ "$1" == "-" ]; then
		# Go back to the last directory on the stack.
		builtin popd > /dev/null;
		pwd # Print the directory as a reminder.
	elif [ -z "$1" ]; then
		builtin pushd ~ >/dev/null;
	else
		builtin pushd "$1" >/dev/null;
	fi
}
alias ocd="builtin cd"

# Go up to a containing directory.
function up () {
	if [[ -z "$1" ]]; then
		# No args? Just go up one level.
		gotodir=..
	else
		# Otherwise set CDPATH to all directories above this one then try to
		# cd.
		gotodir="$1"
		local CDPATH=
		dir=$(pwd)
		while [[ $dir != / ]]; do
			dir=$(dirname $dir)
			CDPATH+=:$dir
		done
	fi
	builtin pushd "$gotodir" >/dev/null
	pwd # Print the directory for verification's sake.
}
complete -o dirnames -o nospace -F _upcomp up
function _upcomp () {
	local CDPATH=
	local IFS=$' \n\t'
	dir=$(pwd)
	while [[ $dir != / ]]; do
		dir=$(dirname $dir)
		CDPATH+=:$dir
	done
	# Cheat by piggybacking off cd's built-in completion function. But first
	# find out what it's registered as (probably _cd, but just to be sure...)
	cd_completion=$(complete -p cd | sed 's/.*-F //' | cut -d' ' -f1)
	if [[ -n $cd_completion ]]; then
		$cd_completion cd $2 $3
	else # Doesn't exist? Fall back to just the contents of CDPATH.
		IFS=:
		DIRS=( $CDPATH )
		IFS=$' \n\t'
		for dir in "${DIRS[@]:1}"; do
			dir=$(basename "$dir")
			if [[ $dir == "$2"* ]]; then
				COMPREPLY+=( "$dir"/ )
			fi
		done
	fi
}

function cuke () {
	sudo cucumber -c -r features -r features/steps "$@" 2>&1 | \
		grep -v -e 'warning: class variable access from toplevel' \
	-e 'dscl_cmd'
}

# Help me learn the iproute2 stuff.
alias ifconfig="echo 'Nope. (Use ip addr.)'"

# Help my stupid muscle memory work in spite of myself
alias :x="exit"
alias :q="exit"
alias :Q="exit"
alias :q!="exit"
alias :Q!="exit"
alias :qa="exit"
alias :Qa="exit"
alias :qa!="exit"
alias :Qa!="exit"

alias :vsp="tmux split-window -h"
alias :Vsp="tmux split-window -h"
alias :sp="tmux split-window"
alias :Sp="tmux split-window"
