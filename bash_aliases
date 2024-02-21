#!/bin/bash

alias tclsh='rlwrap tclsh'

# Use Macvim if available

if command -v mvim &>/dev/null; then
	alias vim="mvim -v"
fi

function VIMRUNTIME() {
	echo -n $(vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015')
}

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

function post_cd() { true; }
function cd() {
	if [[ "$1" == "-" ]]; then
		# Go back to the last directory on the stack.
		builtin popd > /dev/null;
		pwd # Print the directory as a reminder.
	elif [[ -z "$1" ]]; then
		builtin pushd ~ >/dev/null;
	else
		builtin pushd "$1" >/dev/null;
	fi
	local result="$?"
	if [[ "$result" != 0 ]]; then
		return $result
	fi
	post_cd
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
	cd "$gotodir" || return 1
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

function repo() {
	local git_dir
	if [[ -e .git ]]; then
		pwd
	elif git_dir=$(upfile .git 2>/dev/null); then
		( builtin cd "$git_dir"/.. && pwd )
	else
		return 1
	fi
}

function upfile() (
	if [[ -z $1 ]]; then
		echo "USAGE: upfile FILENAME" >&2
		return 1
	fi
	while [[ ! -e $1 ]] && [[ $PWD != / ]]; do
		builtin cd ..
	done
	if [[ -e $1 ]]; then
		echo $PWD/$1
	else
		false
	fi
)

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
	cd "$gotodir" >/dev/null
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

function man() {
	local vim_cmd
	local tab='       '

	if (( $# == 2 )) && [[ bash == $1* ]]; then
		vim_cmd=":/^SHELL BUILTIN COMMANDS/;/^\\S/ij /^       $2/"
		MANPAGER="vimpager -c '$vim_cmd'" man bash
	else
		$(which man) "$@"
	fi
}

function cmd_exists() {
	hash "$1" &>/dev/null
}

function genpass() {
	local len=${1:-30}
	LC_CTYPE=C gtr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= < /dev/urandom | head -c "$len"
}

function ktx() {
	if (( $# > 1 )); then echo "USAGE: ktx [CONTEXT]" >&2; return 1; fi
	local selection
	if selection=$(kubectx | fzf -q "$1" -1 -0); then
		kubectx "$selection"
		return
	fi
	if [[ -n $1 ]]; then
		kubectx "$1"
	fi
}

function kns() {
	if (( $# > 1 )); then echo "USAGE: kns [NAMESPACE]" >&2; return 1; fi
	local selection
	if selection=$(kubens | fzf -q "$1" -1 -0); then
		kubens "$selection"
		return
	fi
	if [[ -n $1 ]]; then
		kubens "$1"
	fi
}

function down() {
	local args
	if (( $# > 0 )); then
		args+=(-q "$1")
	fi
	local dir=$(find * -type d -print0 | fzf --read0 -1 -0 "${args[@]}")
	if [[ -z $dir ]]; then
		return 1
	fi
	cd "$dir"
}

function _down_completion() {
	readarray -d '' -t COMPREPLY < <(find * -type d -print0 | fzf --read0 --print0 -f "${COMP_WORDS[1]}")
}
complete -F _down_completion down
