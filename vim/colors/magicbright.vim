" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Andrew Stiles
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
hi Normal guifg=White guibg=black
hi Comment term=bold ctermfg=DarkCyan guifg=#00aaaa
hi Constant term=underline ctermfg=Magenta guifg=#ff55ff
hi Special term=bold ctermfg=DarkMagenta guifg=#aa00aa
hi Identifier term=underline cterm=bold ctermfg=Cyan gui=bold guifg=#55ffff
hi Statement term=bold cterm=NONE ctermfg=Yellow gui=NONE guifg=#ffff55
hi PreProc term=underline ctermfg=LightBlue guifg=#5fd7ff
hi Type term=underline ctermfg=LightGreen gui=NONE guifg=#87ffaf
hi Function term=bold ctermfg=White guifg=White
hi Repeat term=underline ctermfg=White guifg=#ffff55
hi Operator ctermfg=Red guifg=#ff5555
hi Ignore ctermfg=black guifg=bg
hi Error term=reverse ctermbg=Red ctermfg=White guibg=#ff5555 guifg=White
hi Todo term=standout ctermbg=Yellow ctermfg=Black guifg=Blue guibg=Yellow
hi NonText term=bold ctermfg=Blue gui=NONE guifg=#84aeff
hi SpecialKey term=bold ctermfg=60 guifg=#304860
hi Directory term=bold ctermfg=LightBlue guifg=#afffff
hi ErrorMsg term=standout ctermfg=15 ctermbg=1 guifg=White guibg=#c03b3b
hi Visual term=reverse ctermbg=242 guibg=#6c6c6c
hi WarningMsg term=standout ctermfg=224 guifg=#ffd7d7
hi Folded term=standout ctermfg=14 ctermbg=242 guifg=#55ffff guibg=#6c6c6c
hi FoldColumn term=standout ctermfg=14 ctermbg=242 guifg=#55ffff guibg=#878787
hi DiffAdd term=bold ctermbg=18 guibg=#3333aa
hi DiffChange term=bold ctermbg=5 guibg=#aa00cc
hi DiffDelete term=bold ctermfg=White ctermbg=1 guifg=White guibg=#c03b3b
hi DiffText term=reverse cterm=bold ctermfg=Yellow ctermbg=164 gui=bold guifg=Yellow guibg=#aa00cc
hi SpellBad term=reverse ctermbg=9 gui=undercurl guisp=Red
hi SpellCap term=reverse ctermbg=12 gui=undercurl guisp=#7777ff
hi SpellRare term=reverse ctermbg=13 gui=undercurl guisp=Magenta
hi SpellLocal term=underline ctermbg=6 gui=undercurl guisp=Cyan
hi PmenuSel guibg=#6c6c6c
hi PmenuSbar guibg=#878787
hi TabLine guibg=#6c6c6c

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
