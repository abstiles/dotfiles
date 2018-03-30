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
hi Normal guifg=#333333 guibg=Black
hi Comment term=bold ctermfg=203 guifg=#ff5555
hi Constant term=underline ctermfg=34 guifg=#008800
hi Special term=bold ctermfg=83 guifg=#28ff28
hi Identifier term=underline cterm=bold ctermfg=124 gui=bold guifg=#aa0000
hi Statement term=bold cterm=NONE ctermfg=19 gui=NONE guifg=#0000aa
hi PreProc term=underline ctermfg=209 guifg=#a02800
hi Type term=underline ctermfg=89 gui=NONE guifg=#780050
hi Function term=bold ctermfg=White guifg=White
hi Repeat term=underline ctermfg=19 guifg=#0000aa
hi Operator ctermfg=37 guifg=#00aaaa
hi Ignore ctermfg=Black guifg=bg
hi Error term=reverse ctermbg=37 ctermfg=White guibg=#00aaaa guifg=White
hi Todo term=standout ctermbg=19 ctermfg=Black guifg=#7b5100 guibg=#0000aa
hi NonText term=bold ctermfg=94 gui=NONE guifg=#7b5100
hi SpecialKey term=bold ctermfg=144 guifg=#cfb79f
hi Directory term=bold ctermfg=52 guifg=#500000
hi ErrorMsg term=standout ctermfg=White ctermbg=51 guifg=White guibg=#3fc4c4
hi Visual term=reverse ctermbg=246 guibg=#939393
hi WarningMsg term=standout ctermfg=234 guifg=#002828
hi Folded term=standout ctermfg=124 ctermbg=246 guifg=#aa0000 guibg=#939393
hi FoldColumn term=standout ctermfg=124 ctermbg=246 guifg=#aa0000 guibg=#787878
hi DiffAdd term=bold ctermbg=228 guibg=#cccc55
hi DiffChange term=bold ctermbg=157 guibg=#a0ffa0
hi DiffDelete term=bold ctermfg=White ctermbg=51 guifg=White guibg=#3fc4c4
hi DiffText term=reverse cterm=bold ctermfg=19 ctermbg=83 gui=bold guifg=Yellow guibg=#50ff50
hi SpellBad term=reverse ctermbg=37 gui=undercurl guisp=Red
hi SpellCap term=reverse ctermbg=37 gui=undercurl guisp=#888800
hi SpellRare term=reverse ctermbg=34 gui=undercurl guisp=Magenta
hi SpellLocal term=underline ctermbg=203 gui=undercurl guisp=Cyan
hi PmenuSel guibg=#939393
hi PmenuSbar guibg=#787878
hi TabLine guibg=#939393
hi VertSplit guifg=#dddddd guibg=#555555

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
hi WhitespaceErrors term=reverse ctermbg=159 ctermfg=144 gui=undercurl guifg=#cfb79f guisp=DarkSlateGray1

" Also set the powerline colorscheme
call system('cp ~/.config/powerline/colors-original.json ~/.config/powerline/colors.json')
