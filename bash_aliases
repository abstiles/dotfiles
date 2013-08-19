#!/bin/bash

alias tclsh='rlwrap tclsh'
alias windows='XLIB_SKIP_ARGB_VISUALS=1 rdesktop -g 80% -a 16 -T Windows D5125MN9LRZG81.qlogic.org &';
alias windows-fs='XLIB_SKIP_ARGB_VISUALS=1 rdesktop -fK -a 16 -T Windows D5125MN9LRZG81.qlogic.org &';
if [[ $(uname) == Linux || $(uname) == CYGWIN* ]]; then
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
alias locks='ls -l /eplnxbld01/FW/nightly/*.lck'
alias su="su -m"
alias py27="source ~/py27env/bin/activate"
alias vitodo="vim ~/.todo/list.txt"
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

alias cygwin="cygstart mintty screen bash"

# Set Vim's home to be the Windows home, to unify the vimrc location
alias vim="$HOME='$WINHOME' vim"
# The following is actually necessary for stupid reasons:
#     - Need to use cygstart because disown won't work properly.
#     - Need to specially quote arguments to a command executed by cygstart
#       because it screws up arguments with spaces in them.
function gvim() {
	unset _fs
	unset options_done
	_i=0
	for _f in "$@"; do
		# If the argument is a filename, convert it to a Windows-style path,
		# otherwise pass it to gVim as-is.
		if [[ -n "$options_done" || "$_f" != -* ]]; then
			_fs[$_i]='"'`cygpath -m -- "$_f"`'"'
		else
			# gVim treats the argument "--" as the end of options, to resolve
			# any ambiguity where a filename looks like an option.
			if [[ "$_f" == "--" ]]; then
				options_done=1
			fi
			_fs[$_i]='"'"$_f"'"'
		fi
		let _i=$_i+1
	done
	HOME="$WINHOME" cygstart gvim.exe ${_fs[@]}
}

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

alias :vsp="screen -X process v"
alias :Vsp="screen -X process v"
alias :sp="screen -X process s"
alias :Sp="screen -X process s"

#for folder in $(find ~/git_repo -maxdepth 1 -mindepth 1 -type d -printf '%P\n'); do
#	alias $folder="cd ~/git_repo/$folder"
#done

REPODIRS="$HOME/git_repo/* $HOME/inventory_manager $HOME/projects/bugzilla/bugzilla_templates"
alias thisweekhere='git log --author=${USER:0:1}*${USER:1} --since="last Sunday" --date=local --pretty="format:%Cblue[%ad]%Cred <`basename $PWD`> %Creset%s"'
alias lastweekhere='git log --author=${USER:0:1}*${USER:1} --since="1 week ago" --date=local --pretty="format:%Cblue[%ad]%Cred <`basename $PWD`> %Creset%s"'
alias thisweek='(for dir in '$REPODIRS'; do pushd "$dir" >/dev/null; thisweekhere; echo; popd >/dev/null; done) | sed "/^\$/d" | sort --key=3 -n | sort -M -s --key=2,2'
alias lastweek='(for dir in '$REPODIRS'; do pushd "$dir" >/dev/null; lastweekhere; echo; popd >/dev/null; done) | sed "/^\$/d" | sort --key=3 -n | sort -M -s --key=2,2'
unset REPODIRS
