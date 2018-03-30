#!/bin/bash

alias tclsh='rlwrap tclsh'

if command -v gls &>/dev/null; then
	alias ls="gls --color=auto"
	alias l="gls --color=never -CF"
	alias la="ls -A"
	unalias ll &>/dev/null
	function ll () { gls --color=always -hAlF "$@" | less -FXR; }
else
	alias ls='/bin/ls -G'
fi
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias view='vim -R'
alias su="su -m"
alias copy="xclip -selection CLIPBOARD"
alias vitodo="vim ~/.todo/list.txt"
alias info="info --vi-keys"
alias df="df -Ph"

alias browser='if [[ -z "$BROWSER" ]]; then echo "Environment variable \$BROWSER not set!"; else ($BROWSER &>/dev/null &); fi'

# Use Macvim if available

if command -v mvim &>/dev/null; then
	alias vim="mvim -v"
fi

function cd () {
	if [ "$1" == "-" ]; then
		# Go back to the last directory on the stack.
		builtin popd > /dev/null;
		pwd # Print the directory as a reminder.
	elif [ -z "$1" ]; then
		builtin pushd ~ >/dev/null;
	else
		builtin pushd "$1" >/dev/null;
	fi
}
alias ocd="builtin cd"

# Go up to a containing directory.
function up () {
	if [[ -z "$1" ]]; then
		# No args? Just go up one level.
		gotodir=..
	else
		# Otherwise set CDPATH to all directories above this one then try to
		# cd.
		gotodir="$1"
		local CDPATH=
		dir=$(pwd)
		while [[ $dir != / ]]; do
			dir=$(dirname "$dir")
			CDPATH+=:$dir
		done
	fi
	builtin pushd "$gotodir" >/dev/null
	pwd # Print the directory for verification's sake.
}
complete -o dirnames -o nospace -F _upcomp up
function _upcomp () {
	local CDPATH=
	local IFS=$' \n\t'
	dir=$(pwd)
	while [[ $dir != / ]]; do
		dir=$(dirname "$dir")
		CDPATH+=:$dir
	done
	# Cheat by piggybacking off cd's built-in completion function. But first
	# find out what it's registered as (probably _cd, but just to be sure...)
	cd_completion=$(complete -p cd | sed 's/.*-F //' | cut -d' ' -f1)
	if [[ -n $cd_completion ]]; then
		$cd_completion cd "$2" "$3"
	else # Doesn't exist? Fall back to just the contents of CDPATH.
		IFS=:
		DIRS=( $CDPATH )
		IFS=$' \n\t'
		for dir in "${DIRS[@]:1}"; do
			dir=$(basename "$dir")
			if [[ $dir == "$2"* ]]; then
				COMPREPLY+=( "$dir"/ )
			fi
		done
	fi
}

function upfile() {
	local dir=$(pwd)
	while [[ $dir != / ]]; do
		dir=$(dirname "$dir")
		CDPATH+=:$dir
	done
}

function c () {
	local CDPATH=
	local IFS=$' \n\t'
	if [[ -z "$1" ]]; then
		# No args? Go home.
		gotodir=~
	else
		IFS=/
		local dir_list=( $1 )
		IFS=$' \n\t'
		dir_list=( "${dir_list[@]/%/*}" )
		IFS=/
		local glob="${dir_list[*]}"
		IFS=$' \n\t'
		local expanded_list=( $glob )
		if (( "${#expanded_list[@]}" > 1 )); then
			echo 'Ambiguous navigation. Possibilities:' >&2
			printf '  %s\n' "${expanded_list[@]}" >&2
			return 1
		elif (( "${#expanded_list[@]}" < 1 )); then
			echo 'No matching directory found.' >&2
			return 1
		fi
		gotodir="$expanded_list"
	fi
	builtin pushd "$gotodir" >/dev/null
	pwd # Print the directory for verification's sake.
}

function headline () {
	if command -v figlet &> /dev/null; then
		local text="$*"
		figlet -w "$(tput cols)" -cf banner3 <<< "${text// /  }"
	else
		echo "Requires \"figlet\" to be installed."
	fi
}

function cuke () {
	sudo cucumber -c -r features -r features/steps "$@" 2>&1 | \
		grep -v -e 'warning: class variable access from toplevel' \
	-e 'dscl_cmd'
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

function vsp() {
	if (( $# )); then
		local size=$(( 100 * $# / ($# + 1) ))
		tmux split-window -hp "$size" "vim -O$(printf " %q" "$@")"
	else
		tmux split-window -h
	fi
}

function sp() {
	if (( $# )); then
		local size=$(( 100 * $# / ($# + 1) ))
		tmux split-window -p "$size" "vim -o$(printf " %q" "$@")"
	else
		tmux split-window
	fi
}

alias :vsp="vsp"
alias :Vsp="vsp"
alias :sp="sp"
alias :Sp="sp"

for folder in $(find ~/git_repo/ -maxdepth 1 -mindepth 1 -type d -exec basename {} \;); do
	folder_alias=${folder// /_}
	eval "$folder_alias() { cd ~/git_repo/'$folder'/\"\${1:-/}\" && pwd; }"
	eval "complete -o nospace -F _cd_$folder_alias $folder_alias"
	eval "_cd_$folder_alias() { local CDPATH='~/git_repo/$folder'; _cd \"\$2\" \"\$3\"; }"
done

unalias gradle &>/dev/null
function gradle() {
	local gradle
	if [[ -x ./gradlew ]]; then
		gradle=./gradlew
	else
		gradle=$(type -P gradle)
	fi
	"$gradle" --daemon --parallel --configure-on-demand --continue "$@"
}

function search() {
	if command -v ag >/dev/null; then
		ag -aig "$1\$" "${2:-.}"
	else
		find "${2:-.}" -iregex ".*$1.*"
	fi
}

function invert() {
	if [[ $1 == "off" ]]; then
		cp ~/dir_colors.original ~/.dir_colors
		cp ~/vim_colorscheme.original ~/.vim_colorscheme
		cp ~/original_colors/* /Applications/HipChat.app/Contents/Resources/
		tmux source-file ~/.tmux.conf
	else
		cp ~/dir_colors.inverted ~/.dir_colors
		cp ~/vim_colorscheme.inverted ~/.vim_colorscheme
		cp ~/inverted_colors/* /Applications/HipChat.app/Contents/Resources/
		tmux source-file ~/tmux-inverted.conf
	fi
	eval $(gdircolors -b ~/.dir_colors)
	pkill HipChat && sleep 2 && open /Applications/HipChat.app
}

function scratch() {
	local scratchfile
	scratchfile=$(mktemp -t scratchfile) || return 1
	${EDITOR:-vim} "$scratchfile"
	pbcopy < "$scratchfile"
}

function extract() {
	local success
	local is_done=0
	while ! (( is_done )); do
		is_done=1
		for file in ./*; do
			tar -xvf "$file" 2>/dev/null
			success=$?
			(( success == 0 )) && rm "$file"
			is_done=$(( is_done & success ))
		done
	done
	for file in ./*; do {
		gunzip "$file" && rm "$file"
		unzip "$file" && rm "$file"
		bunzip2 "$file" && rm "$file"
	} 2>/dev/null; done
}

function testrail() (
	if [[ "$1" == "--production" ]]; then
		target=PRODUCTION
	else
		target=SANDBOX
		security export -k /Library/Keychains/System.keychain -t certs -f pemseq \
			-o "/tmp/osx_keystore.pem" 2>/dev/null || exit 1
		export REQUESTS_CA_BUNDLE=/tmp/osx_keystore.pem
	fi
	if [[ -r ~/.web_services.yml ]]; then
		ipy_session_cmd=("from pylib_local.web_services.credentials import *;"
			"Session(target=${target}_TESTRAIL, credentials=Credentials.load_file("
				"'~/.web_services.yml')['${target}']).make_default()"
		)
	else
		ipy_session_cmd="Session.start('andrew.stiles')"
	fi
	export PYTHONPATH=~/git_repo/autotools/tools
	ipython2 --no-banner -ic \
		"from pylib_local.web_services.testrail import *; ${ipy_session_cmd[*]}"
)
