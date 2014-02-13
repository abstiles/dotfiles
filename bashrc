add_path() {
	clear_first=0
	while (( $# > 0 )); do
		case "$1" in
			-f|--force)
				clear_first=1
				;;
			-t|--top)
				shift
				if [[ $clear_first == 1 ]]; then
					PATH=${PATH//$1:/}
					PATH=${PATH//:$1/}
				fi
				[[ $PATH == *$1* ]] || PATH=$1:$PATH
				;;
			-b|--bottom)
				shift
				;&
			*)
				if [[ $clear_first == 1 ]]; then
					PATH=${PATH//$1:/}
					PATH=${PATH//:$1/}
				fi
				[[ $PATH == *$1* ]] || PATH+=:$1
		esac
		shift
	done
}

# Configure the PATH
add_path -f -t /usr/bin
add_path -t `readlink -f $HOME`/scripts
export PATH;

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

if [[ ( "$TERM" == "screen-256color" ) ]]; then
	# screen-256color may not exist -- fall back to "screen" if necessary
	if ! (tput -Tscreen-256color colors &>/dev/null); then
		TERM=screen
		source /etc/profile
	fi
fi

if [[ -z "$DISPLAY" ]]; then DISPLAY=:0.0; fi

if [ -t 0 ]; then
	stty -ixon
fi

export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/local/lib/pkgconfig"
export TCLLIBPATH="~/tcl_packages"
export BROWSER=/usr/bin/chromium
type vless &>/dev/null && { export MANPAGER=vless; }

function VIMRUNTIME() {
	echo -n `vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015'`
}

source ~/.bash_aliases

source ~/.bash_prompt

if [ -f ~/.dir_colors ]; then eval $(dircolors -b ~/.dir_colors); fi

if [ -f /etc/bash_completion ]; then source /etc/bash_completion; fi
