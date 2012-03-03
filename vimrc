set nocompatible
set autoindent
set tabstop=4
set shiftwidth=4
set showmatch
set ruler
set incsearch
set nowrap
set splitright

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

"Cosmetic stuff
syntax enable
set background=dark
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
set title

"Enables block selection past the end of a line
set ve+=block

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

let &titleold=getcwd()

" Emacs-like shortcuts in insert mode
noremap! <C-a> <Home>
noremap! <C-e> <End>

" Ctrl-y to copy selection to clipboard
noremap <C-y> "+y
noremap <C-p> "+p

" Open tag in vertical split
map ] :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Highlight whitespace errors
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$\| \+\ze\t/
autocmd InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd BufWinLeave * call clearmatches()
