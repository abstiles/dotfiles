set nocompatible
set autoindent
set tabstop=4
set shiftwidth=4
set showmatch
set ruler
set incsearch
set hlsearch
set nowrap
set splitright
set ve+=block
set backspace=indent,eol,start

" Set 'space' as the leader key
nnoremap <SPACE> <Nop>
let mapleader = " "

" Handle plugins"{{{
if v:version >= 700 && (isdirectory(expand('$HOME/vimfiles/bundle/vundle'))
			\ || isdirectory(expand('$HOME/.vim/bundle/vundle')))
	"Required for Vundle
	filetype off
	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc()
	Bundle 'gmarik/vundle'
	filetype plugin indent on

	" My Vundle Bundles
	Bundle 'tpope/vim-surround'
	Bundle 'tpope/vim-repeat'
	Bundle 'tpope/vim-git'
	Bundle 'michaeljsmith/vim-indent-object'
elseif v:version >= 700 && (filereadable(expand("$HOME/vimfiles/autoload/pathogen.vim"))
			\ || filereadable(expand("$HOME/.vim/autoload/pathogen.vim")))
	call pathogen#infect()
	call pathogen#helptags()
	filetype plugin indent on
else
	filetype plugin indent on
endif
"}}}

" Cosmetic stuff"{{{
syntax enable
set background=dark
if has("gui_running")
	colorscheme magicbright
	set guifont=Droid_Sans_Mono_Slashed:h9:cANSI
	set guioptions=egirmL
	" Set initial window size
	set lines=50
	set columns=196
	noremap! <C-S-V> <C-R>+
elseif &diff
	"colorscheme peaksea
else
	colorscheme magicbright
	inoremap jk <Esc>
endif
set title
"}}}

" Automatically resize splits as needed
autocmd VimResized * wincmd =

"Settings for starting a diff
"autocmd FilterWritePre * if &diff | set background=dark | colorscheme peaksea | endif
autocmd FilterWritePre * if &diff | set background=dark | endif

"Settings for .txt files
autocmd BufRead,BufNewFile *.txt setl filetype=plaintext
autocmd FileType plaintext setl tw=0
autocmd FileType plaintext setl wrap
autocmd FileType plaintext setl linebreak
autocmd FileType plaintext nnoremap <buffer> j gj
autocmd FileType plaintext nnoremap <buffer> k gk

"Settings for README files
autocmd BufRead,BufNewFile README setl filetype=readme
autocmd FileType readme setl tw=80

"Syntax for testlink case files
au BufRead,BufNewFile *.tlink setl filetype=testlink
au! Syntax testlink source $HOME/.vim/testlink.vim

"Get highlight info
autocmd FileType vim map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Convenience mappings"{{{
" Maps Ctrl-arrows to resizing a window split
map <silent> <C-Left> <C-w><
map <silent> <C-Down> <C-W>-
map <silent> <C-Up> <C-W>+
map <silent> <C-Right> <C-w>>

" Maps zg to centering a line on the screen, giving it a kind of parity with
" zt and zb:
" q w e r|t|y u i o p
"  a s d f|g|h j k l ;
"   z x c v|b|n m , . /
map zg zz

" More convenient fold navigation
map <C-j> zj
map <C-k> zk

" Sloppy finger mappings
command Q q
command W w
command Wq wq
command WQ wq

" Emacs-like shortcuts in insert mode
noremap! <C-a> <Home>
noremap! <C-e> <End>

" Ctrl-y to copy selection to clipboard
if has("clipboard")
	noremap <C-y> "+y
	noremap <C-p> "+p
endif

" Open tag in vertical split
map ] :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Fix wonky syntax highlighting by rescanning file
inoremap <C-L> <Esc>:syntax sync fromstart<CR>
nnoremap <C-L> :syntax sync fromstart<CR>

command Cleardiff diffoff

" Write file with sudo permissions
cnoremap w!! w !sudo tee > /dev/null %
command Sudow write !sudo tee > /dev/null %
"}}}

" Highlight whitespace errors"{{{
if v:version >= 700
	highlight ExtraWhitespace ctermbg=red guibg=red
	match ExtraWhitespace /\s\+$\| \+\ze\t/
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$\| \+\ze\t/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t/
endif
if v:version >= 720
	autocmd BufWinLeave * call clearmatches()
else
	autocmd BufWinLeave * match none
endif"}}}

" LaTeX settings"{{{
":let Tex_FoldedSections=""
:let Tex_FoldedEnvironments=""
:let Tex_FoldedMisc="""}}}

" Vimux mappings"{{{
if $TMUX != ""
	autocmd VimLeave * VimuxCloseRunner
	map <Leader>vp :call VimuxPromptCommand()<CR>
	map <Leader>vr :call VimuxRunCommand("clear; " . expand("%:p"))<CR>
	map <F5> :silent call VimuxRunCommand("clear; make")<CR>
	map <Leader>vv :VimuxRunLastCommand<CR>

	" Easily send commands into the runner pane"{{{
	nnoremap <Leader>vs :set operatorfunc=SendToVimux<cr>g@
	vnoremap <Leader>vs :<c-u>call SendToVimux(visualmode())<cr>
	function! SendToVimux(type)"{{{
		let saved_register = @@
		let current_top = line('w0')
		let current_line = line('.')
		let current_col = col('.')

		if a:type ==# 'v'
			normal! `<v`>y
		elseif a:type ==# 'V'
			normal! `<V`>y
		elseif a:type ==# 'char'
			normal! `[v`]y
		elseif a:type ==# "^V"
			silent execute "normal! `[\<C-V>`]y"
		else
			normal! `[v`]y
		endif

		call VimuxRunCommand(substitute(@", "\n*$", "", "") . "\n", 0)

		call cursor(current_top, 1)
		normal! zt
		call cursor(current_line, current_col)
		let @@ = saved_register
	endfunction
endif"}}}"}}}"}}}

set tags=./tags,tags;

" Mouse support
if has("mouse")
	set mouse=a
endif

" Configure statusline with fugitive
set laststatus=2
set statusline=%<
"set statusline+=%<%f
set statusline+=%{substitute(expand('%:f'),'^fugitive://.*//[^/]*/','fugitive://','')}
set statusline+=\ %h%m%r
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
set statusline+=\ %=%-14.(%l,%c%V%)
set statusline+=\ %P


" vim: foldmethod=marker
