#!/bin/bash

if [ "$COLORTERM" = "gnome-terminal" ]; then
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
