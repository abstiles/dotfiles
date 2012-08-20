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
let mapleader = ","

" Handle plugins"{{{
if v:version >= 700 && isdirectory(expand('~/.vim/bundle/vundle'))
	"Required for Vundle
	filetype off
	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc()
	Bundle 'gmarik/vundle'
	filetype plugin indent on

	" My Vundle Bundles
	Bundle 'altercation/vim-colors-solarized'
	Bundle 'tpope/vim-surround'
	Bundle 'tpope/vim-repeat'
	Bundle 'tpope/vim-git'
	Bundle 'michaeljsmith/vim-indent-object'
	Bundle 'indentpython'
	Bundle 'fs111/pydoc.vim'
	Bundle 'abstiles/vim-showposition'
	Bundle 'benmills/vimux'
	Bundle 'vim-scripts/peaksea'
elseif v:version >= 700 && filereadable(expand("~/.vim/autoload/pathogen.vim"))
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
	let g:solarized_termtrans=1
	" let g:solarized_degrade=0
	let g:solarized_bold=1
	" let g:solarized_underline=1
	" let g:solarized_italic=1
	" let g:solarized_termcolors=16
	" let g:solarized_contrast="normal"
	" let g:solarized_visibility="normal"
	" let g:solarized_diffmode="normal"
	" let g:solarized_hitrail=0
	" let g:solarized_menu=1
	colorscheme solarized
elseif &diff
	colorscheme peaksea
else
	colorscheme elflord
endif
set title
"}}}

"Settings for starting a diff
autocmd FilterWritePre * if &diff | set background=dark | colorscheme peaksea | endif

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

command Cleardiff diffoff | colorscheme elflord
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
	autocmd VimLeave * call VimuxCloseRunner()<CR>
	map <Leader>vp :call VimuxPromptCommand()<CR>
	map <Leader>vr :call VimuxRunCommand("clear; " . expand("%:p"))<CR>
	map <F5> :call VimuxRunCommand("clear; " . expand("%:p"))<CR>
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

" vim: foldmethod=marker
