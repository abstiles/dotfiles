#!/bin/bash

alias tclsh='rlwrap tclsh'
if [[ $(uname) == Linux ]]; then
	alias ls='ls --color=auto'
	alias l='/bin/ls --color=never -CF'
	alias la='ls -A'
	alias ll='ls --color=always -hAlF | less -r'
	alias grep='grep --color=auto'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'
else
	alias ls='ls -G'
fi
alias view='vim -R'
alias su="su -m"
alias copy="xclip -selection CLIPBOARD"
alias info="info --vi-keys"
alias df="df -Ph | sed 's/Mounted on/Mounted_on/' | column -t | sed 's/Mounted_on/Mounted on/'"

alias browser='if [[ -z "$BROWSER" ]]; then echo "Environment variable \$BROWSER not set!"; else ($BROWSER &>/dev/null &); fi'

function cd () {
	if [ "$1" == "-" ]; then
		builtin popd > /dev/null;
	elif [ -z "$1" ]; then
		builtin pushd ~ >/dev/null;
	else
		builtin pushd "$1" >/dev/null;
	fi
}
alias ocd="builtin cd"

# Help me learn the iproute2 stuff.
alias ifconfig="echo 'Nope. (Use ip addr.)'"

# Help my stupid muscle memory work in spite of myself
alias :x="exit"
alias :q="exit"
alias :Q="exit"
alias :q!="exit"
alias :Q!="exit"
