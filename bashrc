#!/bin/bash

# This is how gnome-terminal identifies itself.
if [[ ( "$COLORTERM" == "gnome-terminal" ) && ( $TERM == xterm* ) ]]; then
	# Set the TERM value to something with an appropriate termcap entry and
	# reload /etc/profile to ensure TERM-specific settings are correct
	TERM=gnome-256color
	source /etc/profile
fi

export BROWSER=/usr/bin/chromium
export MANPAGER=vless

function VIMRUNTIME() {
	echo -n `vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015'`
}

source ~/.bash_prompt
source ~/.bash_aliases
