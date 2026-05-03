set nocompatible
set nojoinspaces
set spellcapcheck=
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
set shortmess+=c
set noshowmode
set updatetime=100
set hidden
set autowrite
if ! has('nvim')
	set completeopt=menuone,noinsert,popuphidden
	set completepopup=highlight:PmenuSel,border:off
else
	set completeopt=menu,preview
endif

let g:python3_host_prog = "/opt/homebrew/opt/python@3.11/bin/python3.11"

let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"
let &t_8u = "\e[58;2;%lu;%lu;%lum"
let &t_AU = "\e[58;5;%dm"

nnoremap // :nohlsearch<CR>
" Set 'space' as the leader key
nnoremap <SPACE> <Nop>
let mapleader = " "
let maplocalleader = " "
noremap! <C-H> <C-K>
digraph -n 8211 " En dash
digraph -m 8212 " Em dash
digraph -- 8212 " Em dash
" Make adding to the main dictionary less easy than the temporary one.
noremap zG zg
noremap zg zG
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprev<CR>
nnoremap <C-l> <ESC>:tabnext<CR>
nnoremap <C-h> <ESC>:tabprev<CR>

" Handle plugins"{{{
if v:version >= 700 && filereadable(expand("$HOME/.vim/autoload/pathogen.vim"))
	call pathogen#infect()
	call pathogen#helptags()
endif
filetype plugin indent on
set rtp+=/opt/homebrew/opt/fzf
"}}}

" Cosmetic stuff"{{{
syntax enable
set background=dark
colorscheme magicbright
if has("gui_running")
	set guifont=DroidSansMonoSlashedPerfect:h14
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

" Highlight whitespace errors"{{{
set listchars=tab:··¦,trail:…
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

"Settings for Markdown
augroup MarkdownOptions
	autocmd!
	autocmd FileType markdown setl spell spelllang=en_us
	function! AutoSpellGoodWords()
		let l:goodwords_start = search('<!-- spelldict:', 'wcn')
		let l:goodwords_end = search('<!-- spelldict:\_.*\zs-->', 'wcn')
		if l:goodwords_start == 0 || l:goodwords_end == 0
			return
		endif
		silent execute ':spellgood! ' . 'spelldict'
		let l:lines = getline(l:goodwords_start + 1, l:goodwords_end - 1)
		let l:words = []
		call map(l:lines, "add(l:words, v:val)")
		for l:word in l:words
			silent execute ':spellgood! ' . l:word
		endfor
	endfunction
	function! AddGoodWord()
		if mode() ==# 'v'
			let [l:line_start, l:column_start] = getpos("v")[1:2]
			let [l:line_end, l:column_end] = getpos(".")[1:2]
			if (line2byte(l:line_start)+l:column_start) > (line2byte(l:line_end)+l:column_end)
				let [l:line_start, l:column_start, l:line_end, l:column_end] =
					\ [l:line_end, l:column_end, l:line_start, l:column_start]
			end
			let l:lines = getline(l:line_start, l:line_end)
			if len(l:lines) ==# 0
				return
			endif
			let l:lines[-1] = l:lines[-1][: l:column_end - 1]
			let l:lines[0] = l:lines[0][l:column_start - 1:]
			let l:words = [join(l:lines, ' ')]
		else
			let [l:line, l:column_start] = searchpos('\<\w\+\(\S\w\+\)*', 'cbn')
			let [l:line, l:column_end] = searchpos('\w\+\(\S\w\+\)*\>', 'cezn')
			let l:words = getregion(
				\ [0, l:line, l:column_start, 0],
				\ [0, l:line, l:column_end, 0]
				\ )
		endif
		" If it's a possessive, also add the non-possessive version.
		for idx in range(len(l:words))
			if match(l:words[idx], "'s$") >= 0
				call add(l:words, l:words[idx][:-3])
			endif
		endfor
		" If the word is all lowercase, also add the initial capital version.
		for idx in range(len(l:words))
			if match(l:words[idx], '\u') < 0
				call add(l:words, substitute(l:words[idx], '.*', '\u\0', ''))
			endif
		endfor
		let l:goodwords_start = search('<!-- spelldict:', 'wcn')
		let l:goodwords_end = search('<!-- spelldict:\_.*\zs-->', 'wcn')
		if l:goodwords_start == 0 || l:goodwords_end == 0
			silent execute ':spellgood! ' . 'spelldict'
			let l:result = append(line('$'), ['', '<!-- spelldict:'] + l:words + ['-->'])
		else
			let l:result = append(l:goodwords_end - 1, l:words)
		endif
		for word in l:words
			silent execute ':spellgood! ' . word
		endfor
		silent! call repeat#set("\<Plug>AddFileWord", v:count)
	endfunction
	function! VAddGoodWord() range
		normal! gv
		call AddGoodWord()
		normal! v
	endfunction
	autocmd BufReadPost *.md call AutoSpellGoodWords()
	autocmd FileType markdown noremap <silent> <Plug>AddFileWord :call AddGoodWord()<CR>
	autocmd FileType markdown nnoremap <silent> zg :call AddGoodWord()<CR>
	autocmd FileType markdown xnoremap <silent> zg :call VAddGoodWord()<CR>
	autocmd FileType markdown noremap <silent> zG zg
augroup END

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
autocmd FileType java setl softtabstop=2

" Settings for go files
augroup CustomGoOptions
	autocmd!
	autocmd FileType go setlocal wrap
	autocmd FileType go setlocal breakat=\ (),:
	autocmd FileType go setlocal linebreak
	autocmd FileType go setlocal breakindent
	autocmd FileType go setlocal breakindentopt=shift:2,min:20,sbr
	autocmd FileType go setlocal showbreak=\ ↪
	autocmd FileType go setlocal listchars=tab:\ \ ¦,trail:…,lead:…
augroup END

" Settings for C# files
augroup CustomCSharpOptions
	autocmd!
	autocmd FileType cs setl expandtab
	autocmd FileType cs setl shiftwidth=2
	autocmd FileType cs setl softtabstop=2
augroup END

" Settings for XML files
augroup CustomXMLOptions
	autocmd!
	autocmd FileType xml setl expandtab
	autocmd FileType xml setl shiftwidth=2
	autocmd FileType xml setl softtabstop=2
	autocmd FileType xml setl formatexpr=myxmlformat#Format()
augroup END

"}}}

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
" map ] :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Fix wonky syntax highlighting by rescanning file
" inoremap <C-L> <Esc>:syntax sync fromstart<CR>
" nnoremap <C-L> :syntax sync fromstart<CR>

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
"if ! has('nvim') && has('python3')
"	"set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim/
"python3 << EOF
"try:
"	from powerline.vim import setup as powerline_setup
"	powerline_setup()
"	del powerline_setup
"except ImportError:
"	# Just shut up if it's not installed, I'll deal without it.
"	pass
"EOF
""endif
"else
	let g:airline_powerline_fonts = 1
	let g:airline_theme = 'dark'
	let g:deus_termcolors = 256
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#ale#enabled = 1
	" For some reason this theme needs to be set later in the process or else
	" the colors are incorrect.
	autocmd User AirlineAfterInit AirlineTheme deus
	" Because my font doesn't support the powerline column number character
	" \ue0a3: 
	if !exists('g:airline_symbols')
		let g:airline_symbols = {}
	endif
	let g:airline_symbols.colnr = " \u2105"
	let g:airline_symbols.notexists = "\u1d58"
"endif

" Deal with wrapped lines gracefully
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Helpers to wrap/unwrap markdown text
command! -range Unwrap :<line1>,<line2>call Unwrap()

function! Unwrap(type = '') range
	if a:type == 'char' || a:type == 'line'
		let start = getpos("'[")[1]
		let end = getpos("']")[1]
	else
		let start = a:firstline
		let end = a:lastline
	endif
	execute start . ',' . end . 'g/./,-/\n$/j'
endfunction

onoremap <silent> iP :<C-U>execute "normal! ?\\v(^\\s*\|---)\\zs$\r:nohlsearch\rjv}"<CR>
nnoremap gQQ :<C-U>execute "normal! ?\\v(^\\s*\|---)\\zs$\r:nohlsearch\rjv}:Unwrap\r"<CR>
nnoremap gqq :<C-U>execute "normal! ?\\v^(\\s*\|---)\\zs$\r:nohlsearch\rjv}gq"<CR>
nnoremap gQ :set operatorfunc=Unwrap<CR>g@
vnoremap <silent> gQ :Unwrap<CR>

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
" Toggle popup help
let g:ycm_auto_hover=''

function YcmTagJump()
	" Store where we're jumping from.
	let pos = [bufnr()] + getcurpos()[1:]
	let item = {'bufnr': pos[0], 'from': pos, 'tagname': expand('<cword>')}
	YcmCompleter GoTo

	" Assuming jump was successful, write to tag stack.
	let winid = win_getid()
	let stack = gettagstack(winid)
	let stack['items'] = [item]
	call settagstack(winid, stack, 't')
endfunction
if exists('g:ycm_loaded')
	nmap <Leader><Space> <plug>(YCMHover)
	nnoremap <C-]> :call YcmTagJump()<CR>
endif
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

" FZF settings "{{{
" Look for instances of the word under the cursor
" nnoremap <silent> <C-\> :Ag \b<C-R><C-W>\b<CR>
nnoremap <silent> <C-\> :execute 'Ag \b' .. expand("<cword>") .. '\b'<CR>
nnoremap <Leader>/ :BLines<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6 } }
let g:OmniSharp_fzf_options = g:fzf_layout
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'hl+':     ['fg', 'Comment'],
  \ 'prompt':  ['fg', 'PreProc'],
  \ 'marker':  ['fg', 'PreProc'],
  \ 'info':    ['fg', 'Statement'],
  \ 'border':  ['fg', 'Normal'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
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

" Denite settings "{{{
if exists('denite')
nnoremap <Leader>m :Denite menu<CR>
nnoremap <leader>gg :Denite -start-filter -auto-resize grep<CR>
if ! has("nvim")
	nnoremap <Leader>ef :Denite -start-filter -direction=dynamicbottom -auto-resize file/rec<CR>
else
	nnoremap <Leader>ef :Denite -start-filter -split=floating -auto-resize file/rec<CR>
endif
" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
	nnoremap <silent><buffer><expr> <CR>
		\ denite#do_map('do_action')
	nnoremap <silent><buffer><expr> d
		\ denite#do_map('do_action', 'delete')
	nnoremap <silent><buffer><expr> e
		\ denite#do_map('do_action', 'open')
	nnoremap <silent><buffer><expr> s
		\ denite#do_map('do_action', 'split')
	nnoremap <silent><buffer><expr> v
		\ denite#do_map('do_action', 'vsplit')
	nnoremap <silent><buffer><expr> p
		\ denite#do_map('do_action', 'preview')
	nnoremap <silent><buffer><expr> q
		\ denite#do_map('quit')
	nnoremap <silent><buffer><expr> i
		\ denite#do_map('open_filter_buffer')
	nnoremap <silent><buffer><expr> <Space>
		\ denite#do_map('toggle_select').'j'
endfunction
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
	imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
	call deoplete#custom#buffer_option('auto_complete', v:false)
endfunction
" Change file/rec command.
call denite#custom#var('file/rec', 'command',
	\ ['ag', '--follow', '--nocolor', '--nogroup', '--ignore', 'vendor', '-g', ''])
" Change matchers.
call denite#custom#source(
	\ 'file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
call denite#custom#source(
	\ 'file/rec', 'matchers', ['matcher/cpsm'])
" Change sorters.
call denite#custom#source(
	\ 'file/rec', 'sorters', ['sorter/sublime'])
" Change default action.
call denite#custom#kind('file', 'default_action', 'vsplit')
" Add custom menus
let s:menus = {}
let s:menus.config = {
	\ 'description': 'Edit your config files'
	\ }
let s:menus.config.file_candidates = [
	\ ['vimrc', '~/.vimrc'],
	\ ['bashrc', '~/.bashrc'],
	\ ['bash_aliases', '~/.bash_aliases'],
	\ ]
let s:menus.debug_commands = {
	\ 'description': 'Debug commands'
	\ }
" Hardcoding the menu to use the vimspector human-mode bindings.
let g:vimspector_enable_mappings = 'HUMAN'
let s:menus.debug_commands.command_candidates = [
	\ ['Stop (F3)', 'call vimspector#Stop()'],
	\ ['Restart (F4)', 'call vimspector#Restart()'],
	\ ['Continue (F5)', 'call vimspector#Continue()'],
	\ ['Pause (F6)', 'call vimspector#Pause()'],
	\ ['Add Function Breakpoint (F8)', 'execute "normal \<Plug>VimspectorAddFunctionBreakpoint"'],
	\ ['Run to Cursor (<leader>F8)', 'call vimspector#RunToCursor()'],
	\ ['Toggle Breakpoint (F9)', 'call vimspector#ToggleBreakpoint()'],
	\ ['Step Over (F10)', 'call vimspector#StepOver()'],
	\ ['Step Into (F11)', 'call vimspector#StepInto()'],
	\ ['Step Out (F12)', 'call vimspector#StepOut()'],
	\ ['Go To Current Line', 'call vimspector#GoToCurrentLine()'],
	\ ['List Breakpoints', 'call vimspector#ListBreakpoints()'],
	\ ]
call denite#custom#var('menu', 'menus', s:menus)
" Ag command on grep source
call denite#custom#var('grep', {
	\ 'command': ['ag'],
	\ 'default_opts': ['-i', '--vimgrep', '--ignore', 'vendor'],
	\ 'recursive_opts': [],
	\ 'pattern_opt': [],
	\ 'separator': ['--'],
	\ 'final_opts': [],
	\ })
" Specify multiple paths in grep source
"call denite#start([{'name': 'grep',
"      \ 'args': [['a.vim', 'b.vim'], '', 'pattern']}])
" Define alias
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
	\ ['git', 'ls-files', '-co', '--exclude-standard'])
call denite#custom#alias('source', 'file/rec/py', 'file/rec')
call denite#custom#var('file/rec/py', 'command',
\ ['scantree.py', '--path', ':directory'])
" Change ignore_globs
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
	\ [ '.git/', '.ropeproject/', '__pycache__/',
	\   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
endif
"}}}

" Settings for C#
let g:OmniSharp_server_use_net6 = 1
let g:OmniSharp_selector_findusages = 'fzf'
let g:OmniSharp_popup_position = 'peek'
if has('nvim')
  let g:OmniSharp_popup_options = {
  \ 'winblend': 30,
  \ 'winhl': 'Normal:Normal,FloatBorder:ModeMsg',
  \ 'border': 'rounded'
  \}
else
  let g:OmniSharp_popup_options = {
  \ 'highlight': 'Normal',
  \ 'padding': [0],
  \ 'border': [1],
  \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
  \ 'borderhighlight': ['ModeMsg']
  \}
  let g:ale_floating_preview_popup_opts = {
  \ 'highlight': 'Normal',
  \ 'padding': [0],
  \ 'border': [1],
  \ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
  \ 'borderhighlight': ['ModeMsg'],
  \ 'close': 'click'
  \}
endif
let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>']
\}
let g:ale_linters = {
\ 'cs': ['OmniSharp'],
\ 'python': ['pylint', 'mypy', 'pyright']
\}
let g:ale_fixers = {
\ 'python': ['pyflyby', 'isort', 'autoimport'],
\ 'html': ['tidy']
\}
nnoremap <leader>z <Plug>(ale_fix)
let g:ale_virtualtext_cursor = 0
let g:ale_sign_error = '●︎'
let g:ale_sign_warning = '●︎'
let g:ale_sign_info = '•'
let g:ale_sign_style_error = '•'
let g:ale_sign_style_warning = '•'
let g:ale_set_highlights = 1
let g:ale_cursor_detail = 1
let g:ale_floating_preview = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
inoremap <expr> <Tab>   pumvisible() ? "\<CR>" : "\<Tab>"
let g:sharpenup_map_prefix = ','
let g:sharpenup_codeactions_glyph = "◈"

function TagJumpWrapper(cmd)
	" Store where we're jumping from.
	let pos = [bufnr()] + getcurpos()[1:]
	let item = {'bufnr': pos[0], 'from': pos, 'tagname': expand('<cword>')}
	execute a:cmd
	" Assuming jump was successful, write to tag stack.
	let winid = win_getid()
	let stack = gettagstack(winid)
	let stack['items'] = [item]
	call settagstack(winid, stack, 't')
endfunction

function CSharpSetup()
	if exists('g:OmniSharp_loaded')
		" OmniSharpGotoDefinition
		nnoremap <silent> <buffer> <C-]> :call TagJumpWrapper('OmniSharpGotoDefinition')<CR>
	endif
	highlight SignColumn ctermbg=NONE guibg=NONE
	" highlight Todo       ctermbg=NONE guibg=NONE
	" Link ALE sign highlights to similar equivalents without background colours
	highlight ALEErrorSign ctermfg=196 ctermbg=NONE
	highlight ALEWarningSign ctermfg=227 ctermbg=NONE
	highlight ALEInfoSign ctermfg=87 ctermbg=NONE
endfunction

augroup CustomCSharpOptions
autocmd!
autocmd FileType cs setl expandtab
autocmd FileType cs call CSharpSetup()
augroup END

let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
augroup CustomPythonOptions
autocmd!
autocmd FileType python nnoremap <Leader><Space> <plug>(ale_hover)
autocmd FileType python setl omnifunc=ale#completion#OmniFunc
augroup END

let g:vimspector_enable_mappings = 'HUMAN'

" let g:gutentags_file_list_command = {'markers': {'.pythontags': '/Users/astiles/scripts/py_path_lister.py'} }
" let g:gutentags_trace = 1
" let g:gutentags_ctags_extra_args = [
"       \ '--tag-relative=yes',
"       \ '--fields=+ailmnS',
"       \ ]
"
" let g:gutentags_ctags_exclude = [
"       \ '*.git', '*.svg', '*.hg',
"       \ '*/tests/*',
"       \ 'build',
"       \ 'dist',
"       \ '*sites/*/files/*',
"       \ 'bin',
"       \ 'node_modules',
"       \ 'bower_components',
"       \ 'cache',
"       \ 'compiled',
"       \ 'docs',
"       \ 'example',
"       \ 'bundle',
"       \ 'vendor',
"       \ '*.md',
"       \ '*-lock.json',
"       \ '*.lock',
"       \ '*bundle*.js',
"       \ '*build*.js',
"       \ '.*rc*',
"       \ '*.json',
"       \ '*.min.*',
"       \ '*.map',
"       \ '*.bak',
"       \ '*.zip',
"       \ '*.pyc',
"       \ '*.class',
"       \ '*.sln',
"       \ '*.Master',
"       \ '*.csproj',
"       \ '*.tmp',
"       \ '*.csproj.user',
"       \ '*.cache',
"       \ '*.pdb',
"       \ 'tags*',
"       \ 'cscope.*',
"       \ '*.css',
"       \ '*.less',
"       \ '*.scss',
"       \ '*.exe', '*.dll',
"       \ '*.mp3', '*.ogg', '*.flac',
"       \ '*.swp', '*.swo',
"       \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
"       \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
"       \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
"       \ ]

" vim: foldmethod=marker
