[[ -z "$TMUX" ]] && /usr/local/bin/tmux new-session -A -s main

# Ensure all my parallel tmux bash sessions don't clobber each other's history
shopt -s histappend
# Ignore adjacent duplicate lines and lines beginning with space.
HISTCONTROL=ignoreboth
# Default value: 500
HISTSIZE=10000

export SHELL=$(which bash)
export EDITOR=vim

export VAULT_ADDR=https://vault.kube.jamf.build
export VAULT_SKIP_VERIFY=true

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
					PATH=${PATH//:$1:/:}
					PATH=${PATH##$1:}
					PATH=${PATH%%:$1}
				fi
				PATH=$1:$PATH
				;;
			-b|--bottom)
				;;
			*)
				if [[ $clear_first == 1 ]]; then
					PATH=${PATH//:$1:/:}
					PATH=${PATH##$1:}
					PATH=${PATH%%:$1}
				fi
				PATH+=:$1
		esac
		shift
	done
}

export GOPATH=$HOME/go

# Configure the PATH
add_path -f -t /usr/bin
add_path -f -t /usr/local/bin
add_path -f -t "$HOME/.local/bin"
add_path -t `greadlink -f $HOME`/scripts
add_path -f "$HOME/.cargo/bin"
add_path -f "$GOPATH/bin"
add_path -f /usr/local/opt/go/libexec/bin
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
	#source /etc/profile
fi

# Avoid the fun new quoting behavior in recent GNU coreutils versions.
export QUOTING_STYLE=escape

if [[ ( "$TERM" == "screen-256color" ) ]]; then
	# screen-256color may not exist -- fall back to "screen" if necessary
	if ! (tput -Tscreen-256color colors &>/dev/null); then
		TERM=screen
		#source /etc/profile
	fi
fi

if [[ -z "$DISPLAY" ]]; then DISPLAY=:0.0; fi

if [ -t 0 ]; then
	stty -ixon
fi

export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/local/lib/pkgconfig"
export TCLLIBPATH="~/tcl_packages"

if command -v vimpager &> /dev/null; then
	export PAGER=vimpager
	export MANPAGER=vimpager
else
	export PAGER=less
	export MANPAGER=less
fi

function VIMRUNTIME() {
	echo -n `vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015'`
}

source ~/.bash_aliases

source ~/.bash_prompt

if command -v gdircolors &>/dev/null; then
	if [ -f ~/.dir_colors ]; then eval $(gdircolors -b ~/.dir_colors); fi
fi

if [ -f /etc/bash_completion ]; then source /etc/bash_completion; fi
if [ -f /usr/local/etc/bash_completion ]; then source /usr/local/etc/bash_completion; fi
if [ -f ~/.bash_completion ]; then source ~/.bash_completion; fi
if [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then source /usr/local/etc/profile.d/bash_completion.sh; fi

eval "$(pipenv --completion)"
eval "$(pyenv init -)"
