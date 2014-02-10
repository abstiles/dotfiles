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
alias vitodo="vim ~/.todo/list.txt"
alias info="info --vi-keys"
alias df="df -Ph | sed 's/Mounted on/Mounted_on/' | column -t | sed 's/Mounted_on/Mounted on/'"

alias browser='if [[ -z "$BROWSER" ]]; then echo "Environment variable \$BROWSER not set!"; else ($BROWSER &>/dev/null &); fi'

# Use vim with XClipboard support if it exists as a separate command
type -P vimx &>/dev/null
if [[ $? -eq 0 ]]; then
	alias vim="vimx"
fi

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
function _updirs () {
	IFS='/' read -a DIRS < <(pwd | grep -o '^.*\/');
	# Skip first element, which will always be empty.
	for i in "${DIRS[@]:1}"; do
		if [[ $i == "$2"* ]] || [[ $(printf '%q' "$i") == "$2"* ]]; then
			echo "$i"
		fi
	done
}
complete -o filenames -C _updirs ud
function ud () {
	if [[ -z "$1" ]]; then
		# No args? Go up one level.
		gotodir=..
	else
		# Otherwise go up to the closest directory matching the given name.
		gotodir=$(pwd | grep -io '^.*'"$1"'\/')
	fi
	if [[ -d "$gotodir" ]]; then
		builtin pushd "$gotodir" >/dev/null;
	else
		echo "No such directory." >&2
		return 1
	fi
	pwd # Print the directory for verification's sake.
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
