" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Anjou Stiles
" Last Change:	2013 July 17

" A tweaked and extended version of the built-in Elflord colorscheme. Modified
" to suit my tastes, enhance readability, and make the gVim version more like
" the terminal version with my terminal settings.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "MagicBright"
hi Normal guifg=#cccccc guibg=Black
hi Comment term=bold ctermfg=37 guifg=#00aaaa
hi Constant term=underline ctermfg=207 guifg=#ff77ff
hi Special term=bold ctermfg=127 guifg=#d700d7
hi Identifier term=underline cterm=bold ctermfg=87 gui=bold guifg=#55ffff
hi Statement term=bold cterm=NONE ctermfg=227 gui=NONE guifg=#ffff55
hi PreProc term=underline ctermfg=81 guifg=#5fd7ff
hi Type term=underline ctermfg=121 gui=NONE guifg=#87ffaf
hi Function term=bold ctermfg=White guifg=White
hi Repeat term=underline ctermfg=227 guifg=#ffff55
hi Operator ctermfg=203 guifg=#ff5555
hi Ignore ctermfg=Black guifg=bg
hi Error term=reverse ctermbg=203 ctermfg=White guibg=#ff5555 guifg=White
hi Todo term=standout ctermbg=227 ctermfg=Black guifg=#84aeff guibg=#ffff55
hi NonText term=bold ctermfg=111 gui=NONE guifg=#84aeff
hi SpecialKey term=bold ctermfg=60 guifg=#304860
hi Directory term=bold ctermfg=159 guifg=#afffff
hi ErrorMsg term=standout ctermfg=White ctermbg=196 guifg=White guibg=#c03b3b
hi Visual term=reverse ctermbg=242 guibg=#6c6c6c
hi WarningMsg term=standout ctermfg=224 guifg=#ffd7d7
hi Folded term=standout ctermfg=87 ctermbg=242 guifg=#55ffff guibg=#6c6c6c
hi FoldColumn term=standout ctermfg=87 ctermbg=242 guifg=#55ffff guibg=#878787
hi DiffAdd term=bold ctermbg=18 guibg=#3333aa
hi DiffChange term=bold ctermbg=53 guibg=#5f005f
hi DiffDelete term=bold ctermfg=White ctermbg=196 guifg=White guibg=#c03b3b
hi DiffText term=reverse cterm=bold ctermfg=227 ctermbg=127 gui=bold guifg=Yellow guibg=#af00af
hi SpellBad term=reverse ctermbg=203 gui=undercurl guisp=Red
hi SpellCap term=reverse ctermbg=203 gui=undercurl guisp=#7777ff
hi SpellRare term=reverse ctermbg=207 gui=undercurl guisp=Magenta
hi SpellLocal term=underline ctermbg=37 gui=undercurl guisp=Cyan
hi PmenuSel guibg=#6c6c6c
hi PmenuSbar guibg=#878787
hi TabLine guibg=#6c6c6c
hi VertSplit guifg=#222222 guibg=#aaaaaa
hi NormalFloat ctermbg=232

" Common groups that link to default highlighting.
" You can specify other highlighting easily.
hi link String Constant
hi link Character Constant
hi link Number Constant
hi link Boolean Constant
hi link Float Number
hi link Conditional Repeat
hi link Label Statement
hi link Keyword Statement
hi link Exception Statement
hi link Include PreProc
hi link Define PreProc
hi link Macro PreProc
hi link PreCondit PreProc
hi link StorageClass Type
hi link Structure Type
hi link Typedef Type
hi link Tag Special
hi link SpecialChar Special
hi link Delimiter Special
hi link SpecialComment Special
hi link Debug Special
hi link SpecialKey Identifier
hi clear MoreMsg
hi link MoreMsg Type
hi clear Question
hi link Question Type
hi clear SignColumn
hi link SignColumn FoldColumn

" Custom highlighting group for whitespace errors. Based on SpecialKey for best appearance.
hi WhitespaceErrors term=reverse ctermbg=52 ctermfg=60 gui=undercurl guifg=#304860 guisp=DarkRed
