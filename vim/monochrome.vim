" Vim color scheme
"
" This file is generated, please check bin/generate.rb.
"
" Name:       monochrome.vim
" Maintainer: Xavier Noria <fxn@hashref.com>
" License:    MIT

set background=dark

hi clear
if exists('syntax_on')
   syntax reset
endif

let g:colors_name = 'monochrome'

" These commands are generated, see bin/generate.rb.
hi Normal guifg=LightGray ctermfg=252 guibg=#060608 ctermbg=16 gui=NONE cterm=NONE term=NONE
hi Cursor guifg=Black ctermfg=16 guibg=LightGray ctermbg=252 gui=NONE cterm=NONE term=NONE
hi CursorLine guibg=#202020 ctermbg=234 gui=NONE cterm=NONE term=NONE
hi CursorLineNr guifg=#666666 ctermfg=15 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi ColorColumn guifg=LightGray ctermfg=252 guibg=#202020 ctermbg=234 gui=NONE cterm=NONE term=NONE
hi FoldColumn guifg=DarkGray ctermfg=248 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Folded guifg=#666666 ctermfg=252 guibg=#202020 ctermbg=16 gui=NONE cterm=NONE term=NONE
hi LineNr guifg=DarkGray guifg=#333333 ctermfg=248 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Statement guifg=#e2e2e2 ctermfg=254 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi PreProc guifg=#e2e2e2 ctermfg=254 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi String guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Number guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Boolean guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Character guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Constant guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Operator guifg=#aabbcc ctermfg=147 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Special guifg=#aaaaaa ctermfg=251 guibg=bg ctermbg=bg gui=italic cterm=italic term=italic
hi Comment guifg=#737373 ctermfg=243 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Constant guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Type guifg=#e2e2e2 ctermfg=254 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi StorageClass guifg=#e2e2e2 ctermfg=254 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi Function guifg=#e2e2e2 ctermfg=254 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Identifier guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi MatchParen guifg=Black ctermfg=16 guibg=#ccddee ctermbg=252 gui=NONE cterm=NONE term=NONE
hi rubyConstant guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi rubySharpBang guifg=#737373 ctermfg=243 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi rubyStringDelimiter guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi rubyStringEscape guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi rubyRegexpEscape guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi rubyRegexpAnchor guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi rubyRegexpSpecial guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi perlSharpBang guifg=#737373 ctermfg=243 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi perlStringStartEnd guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi perlStringEscape guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi perlMatchStartEnd guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi pythonEscape guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi javaScriptFunction guifg=#e2e2e2 ctermfg=254 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi elixirDelimiter guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Search guifg=White ctermfg=15 guibg=#778899 ctermbg=67 gui=NONE cterm=NONE term=NONE
hi Visual guifg=White ctermfg=15 guibg=#778899 ctermbg=67 gui=NONE cterm=NONE term=NONE
hi NonText guifg=DarkGray ctermfg=248 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi Directory guifg=White ctermfg=15 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi Title guifg=White ctermfg=15 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi TabLineFill guifg=#303030 guibg=#303030 ctermbg=16
hi TabLine guifg=#909090 ctermfg=15 guibg=#252628 ctermbg=16 gui=NONE cterm=NONE term=NONE
hi markdownHeadingDelimiter guifg=#e2e2e2 ctermfg=254 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi markdownHeadingRule guifg=#e2e2e2 ctermfg=254 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi markdownLinkText guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=underline cterm=underline term=underline
hi Todo guifg=White ctermfg=15 guibg=bg ctermbg=bg gui=bold cterm=bold term=bold
hi Pmenu guifg=White ctermfg=15 guibg=#778899 ctermbg=67 gui=NONE cterm=NONE term=NONE
hi PmenuSel guifg=#778899 ctermfg=67 guibg=White ctermbg=15 gui=NONE cterm=NONE term=NONE
hi helpSpecial guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi helpHyperTextJump guifg=#778899 ctermfg=67 guibg=bg ctermbg=bg gui=underline cterm=underline term=underline
hi helpNote guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimOption guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimGroup guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimHiClear guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimHiGroup guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimHiAttrib guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimHiGui guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimHiGuiFgBg guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimHiCTerm guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimHiCTermFgBg guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimSynType guifg=LightGray ctermfg=252 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
hi vimCommentTitle guifg=#737373 ctermfg=243 guibg=bg ctermbg=bg gui=NONE cterm=NONE term=NONE
