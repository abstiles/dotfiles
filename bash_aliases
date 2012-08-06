#!/bin/bash

alias tclsh='rlwrap tclsh'
alias windows='XLIB_SKIP_ARGB_VISUALS=1 rdesktop -g 80% -a 16 -T Windows D5125MN9LRZG81.qlogic.org &';
alias windows-fs='XLIB_SKIP_ARGB_VISUALS=1 rdesktop -fK -a 16 -T Windows D5125MN9LRZG81.qlogic.org &';
if [[ $(uname) == Linux ]]; then
	alias ls='ls --color=auto'
	alias l='ls -CF'
	alias la='ls -A'
	alias ll='ls -hAlF'
	alias grep='grep --color=auto'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'
else
	alias ls='ls -G'
fi
alias view='vim -R'
alias locks='ls -l /eplnxbld01/FW/nightly/*.lck'
alias testtools='cd ~/git_repo/testbed/tools && export PKGDIR=`pwd`'
alias testscripts='cd ~/git_repo/testbed/scripts && export PKGDIR=`pwd`'
alias autotools='cd ~/git_repo/autotest_tools/tools && export PKGDIR=`pwd`'
alias su="su -m"
alias py27="source ~/py27env/bin/activate"
alias vless="/usr/share/vim/vim70/macros/less.sh"
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
		builtin popd > /dev/null;
	elif [ -z $1 ]; then
		builtin pushd ~ >/dev/null;
	else
		builtin pushd $1 >/dev/null;
	fi
}
alias ocd="builtin cd"

# Help me learn the iproute2 stuff.
alias ifconfig="echo 'Nope. (Use ip addr.)'"
