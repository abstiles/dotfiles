if [ -z $BASHRC_LOADED ]; then
    export BASHRC_LOADED=1
    PATH=`readlink -f $HOME`/scripts:$PATH
    export PATH;
fi

# This is how gnome-terminal identifies itself.
if [[ ( "$COLORTERM" == "gnome-terminal" ) && ( $TERM == xterm* ) ]]; then
	# Set the TERM value to something with an appropriate termcap entry and
	# reload /etc/profile to ensure TERM-specific settings are correct
	TERM=gnome-256color
	source /etc/profile
fi

if [[ ( "$TERM" == "screen-256color" ) ]]; then
	# screen-256color may not exist -- fall back to "screen" if necessary
	if ! (tput -Tscreen-256color colors &>/dev/null); then
		TERM=screen
		source /etc/profile
	fi
fi

if [[ -z "$DISPLAY" ]]; then DISPLAY=:0.0; fi

stty -ixon

export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/local/lib/pkgconfig"
export TCLLIBPATH="~/tcl_packages"

export CVSEDITOR=/usr/bin/vim
export CVSROOT=:ext:astiles@kop-sds-repos.qlogic.org:/cvs
export CVS_RSH=/usr/bin/ssh

export BROWSER=/usr/bin/google-chrome
export MANPAGER=vless

function VIMRUNTIME() {
	echo -n `vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015'`
}

source ~/.bash_aliases

source ~/.bash_prompt

if [ -f /etc/bash_completion ]; then source /etc/bash_completion; fi
