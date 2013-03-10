#!/bin/bash

# Set the TERM value to something with an appropriate termcap entry and
# reload /etc/profile to ensure TERM-specific settings are correct
if [[ $TERM == xterm* ]]; then
	if [[ "$COLORTERM" == "gnome-terminal" ]]; then
		# This is how gnome-terminal identifies itself.
		TERM=gnome-256color
	elif [[ "$COLORTERM" == "xfce4-terminal" ]]; then
		# This is how xfce4-terminal identifies itself.
		TERM=xterm-256color
	fi
	source /etc/profile
fi

if [[ $PATH != *$HOME/scripts* ]]; then
    PATH=`readlink -f $HOME`/scripts:$PATH
    export PATH;
fi

export TCLLIBPATH="~/tcl_packages"
export BROWSER=/usr/bin/chromium
type vless &>/dev/null && { export MANPAGER=vless; }

function VIMRUNTIME() {
	echo -n `vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015'`
}

source ~/.bash_prompt
source ~/.bash_aliases
