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
alias :qa="exit"
alias :Qa="exit"
alias :qa!="exit"
alias :Qa!="exit"

alias :vsp="tmux split-window -h"
alias :Vsp="tmux split-window -h"
alias :sp="tmux split-window"
alias :Sp="tmux split-window"

for folder in $(find ~/git_repo -maxdepth 1 -mindepth 1 -type d -printf '%P\n'); do
	alias $folder="cd ~/git_repo/$folder"
done

REPODIRS="$HOME/git_repo/* $HOME/inventory_manager $HOME/projects/bugzilla/bugzilla_templates"
alias thisweekhere='git log --author=${USER:0:1}*${USER:1} --since="last Sunday" --date=local --pretty="format:%Cblue[%ad]%Cred <`basename $PWD`> %Creset%s"'
alias lastweekhere='git log --author=${USER:0:1}*${USER:1} --since="1 week ago" --date=local --pretty="format:%Cblue[%ad]%Cred <`basename $PWD`> %Creset%s"'
alias thisweek='(for dir in '$REPODIRS'; do pushd "$dir" >/dev/null; thisweekhere; echo; popd >/dev/null; done) | sed "/^\$/d" | sort --key=3 -n | sort -M -s --key=2,2'
alias lastweek='(for dir in '$REPODIRS'; do pushd "$dir" >/dev/null; lastweekhere; echo; popd >/dev/null; done) | sed "/^\$/d" | sort --key=3 -n | sort -M -s --key=2,2'
unset REPODIRS
