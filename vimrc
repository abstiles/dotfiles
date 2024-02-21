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
set formatoptions+=j
set nojoinspaces

" Set 'space' as the leader key
nnoremap <SPACE> <Nop>
let mapleader = " "

" Handle plugins"{{{
if v:version >= 700 && isdirectory(expand('$HOME/.vim/bundle/vundle'))
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
	Bundle 'benmills/vimux'
elseif v:version >= 700 && filereadable(expand("$HOME/.vim/autoload/pathogen.vim"))
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
colorscheme magicbright
if has("gui_running")
	set guifont=Droid\ Sans\ Mono\ Slashed\ Perfect:h11
	set guioptions=egim
	" Set initial window size
	set lines=50
	set columns=196
	set linespace=1
	set fullscreen
endif
" Use the same character for vert splits as Tmux does.
set fillchars+=vert:│
set title
"}}}

"File encoding defaults"{{{
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8                     " better default than latin1
  setglobal fileencoding=utf-8           " change default file encoding when writing new files
endif"}}}

" Automatically resize splits as needed
autocmd VimResized * wincmd =

"Settings for starting a diff
"autocmd FilterWritePre * if &diff | set background=dark | endif

"Personal settings for filetypes"{{{
"Settings for .txt files
autocmd BufRead,BufNewFile *.txt setl filetype=plaintext
autocmd FileType plaintext setl tw=0
autocmd FileType plaintext setl wrap
autocmd FileType plaintext setl linebreak
autocmd FileType plaintext nnoremap <buffer> j gj
autocmd FileType plaintext nnoremap <buffer> k gk

autocmd FileType vimwiki setl foldmethod=syntax
autocmd FileType vimwiki setl foldlevel=1
autocmd FileType vimwiki setl spell spelllang=en_us
" Vimwiki prefers spaces to tabs
autocmd FileType vimwiki setl expandtab
autocmd FileType vimwiki setl textwidth=80
let g:vimwiki_folding='list'

"Settings for README files
autocmd BufRead,BufNewFile README setl filetype=readme
autocmd FileType readme setl tw=80

"Settings for Ruby files
autocmd FileType ruby setl expandtab
autocmd FileType ruby setl shiftwidth=2
autocmd FileType ruby setl tabstop=2
autocmd FileType ruby setl softtabstop=2

"Settings for Cucumber feature files
autocmd FileType cucumber setl expandtab
autocmd FileType cucumber setl shiftwidth=2
autocmd FileType cucumber setl tabstop=2
autocmd FileType cucumber setl softtabstop=2

" Settings for tmux.conf file
autocmd BufRead,BufNewFile .tmux.conf setl filetype=tmux.conf

" Settings for bash files
autocmd FileType sh setl noexpandtab
autocmd FileType sh setl tabstop=4

" Settings for java files
autocmd FileType java setl expandtab
autocmd FileType java setl shiftwidth=2
autocmd FileType java setl tabstop=2
autocmd FileType java setl softtabstop=2 "}}}

"Get highlight info
autocmd FileType vim map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Convenience mappings"{{{
" Quickly close the location list
nnoremap <Leader><Space> :lclose<CR>

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
command! Q q
command! W w
command! Wq wq
command! WQ wq

" Emacs-like shortcuts in insert mode
noremap! <C-a> <Home>
noremap! <C-e> <End>

" Ctrl-y to copy selection to clipboard
if has("clipboard")
	noremap <C-y> "+y
	noremap <C-p> "+p
endif

" Open tag in vertical split
"map ] :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Fix wonky syntax highlighting by rescanning file
inoremap <C-L> <Esc>:syntax sync fromstart<CR>
nnoremap <C-L> :syntax sync fromstart<CR>

command! Cleardiff diffoff

" Write file with sudo permissions
cnoremap w!! w !sudo tee > /dev/null %
command! Sudow write !sudo tee > /dev/null %

" Navigate tabs like my Tmux windows.
if has("gui_running")
	map <C-j> gt
	map <C-k> gT
endif

"}}}

" Highlight whitespace errors"{{{
set listchars=tab:¦·,trail:…
set list
if v:version >= 700
	match WhitespaceErrors /\s\+$\| \+\ze\t/
	autocmd BufWinEnter * match WhitespaceErrors / \+\ze\t/
	autocmd InsertEnter * match WhitespaceErrors /\s\+\%#\@<!$\| \+\ze\t/
	autocmd InsertLeave * match WhitespaceErrors /\s\+$\| \+\ze\t/
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

set tags=./tags,tags;

" Mouse support
if has("mouse")
	set mouse=a
endif
if has("mouse_sgr")
	set ttymouse=sgr
elseif &term =~ '^screen'
	set ttymouse=xterm2
end

" Setup always-on Powerline for the status line
set laststatus=2
if ! has('nvim') && has('python3')
	"set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim/
python3 << EOF
try:
	from powerline.vim import setup as powerline_setup
	powerline_setup()
	del powerline_setup
except ImportError:
	# Just shut up if it's not installed, I'll deal without it.
	pass
EOF
"endif
else
	let g:airline_powerline_fonts = 1
	let g:airline_theme = 'powerline_inverse'
	let g:airline#extensions#tabline#enabled = 1
endif

" Easymotion accessories"{{{
let g:EasyMotion_smartcase = 1
map <Leader> <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-s2)
xmap s <Plug>(easymotion-s2)
omap z <Plug>(easymotion-s2)
nmap <Leader>s <Plug>(easymotion-sn)
xmap <Leader>s <Plug>(easymotion-sn)
omap <Leader>z <Plug>(easymotion-sn)
"}}}

" YouCompleteMe "{{{
nnoremap <Leader>gd :YcmCompleter GoTo<CR>
"}}}

" For gVim: make the 'file has changed' window not appear and be annoying."{{{
" Taken from Vim Wiki Tip 1568
au FileChangedShell * call FCSHandler(expand("<afile>:p"))
function! FCSHandler(name)
  let msg = 'File "'.a:name.'"'
  let v:fcs_choice = ''
  if v:fcs_reason == "deleted"
    let msg .= " no longer available - 'modified' set"
    call setbufvar(expand(a:name), '&modified', '1')
    echohl WarningMsg
  elseif v:fcs_reason == "time"
    let msg .= " timestamp changed"
  elseif v:fcs_reason == "mode"
    let msg .= " permissions changed"
  elseif v:fcs_reason == "changed"
    let msg .= " contents changed"
    let v:fcs_choice = "ask"
  elseif v:fcs_reason == "conflict"
    let msg .= " CONFLICT --"
    let msg .= " is modified, but"
    let msg .= " was changed outside Vim"
    let v:fcs_choice = "ask"
    echohl ErrorMsg
  else  " unknown values (future Vim versions?)
    let msg .= " FileChangedShell reason="
    let msg .= v:fcs_reason
    let v:fcs_choice = "ask"
    echohl ErrorMsg
  endif
  redraw!
  echomsg msg
  echohl None
endfunction"}}}

" Convenient tmux/split navigation "{{{
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
"}}}

" Syntastic settings "{{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8', 'pylint', 'mypy']
let g:syntastic_python_mypy_args = ' --py2 --strict-optional --ignore-missing-imports'
let g:syntastic_enable_signs = 0
let g:syntastic_mode_map = {
	\ "mode": "passive",
	\ "active_filetypes": [],
	\ "passive_filetypes": [] }
let g:syntastic_enable_highlighting = 0
nnoremap <F6> :SyntasticCheck<CR>
"}}}

" vim: foldmethod=marker
