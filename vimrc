" Daybreaker's vimrc
" Maintainer: Joongi Kim (me@daybreaker.info)

set nocompatible
scripte utf-8
let $LANG='ko_KR.UTF-8'
set enc=utf-8

%if vim_colorscheme == "solarized":
let g:solarized_contrast="high"
%end

if has("gui_running") && has("win32")	" For Windows gVim
    source $VIMRUNTIME/delmenu.vim
    set langmenu=ko_kr
    source $VIMRUNTIME/menu.vim

    " Set the initial state of IME as Englinsh for insert/search mode.
    set iminsert=0 imsearch=0

    " Theme
    colorscheme {{vim_colorscheme}}
    set guifont=Consolas:h9:cANSI
    set guifontwide=NanumGothicCoding:h10:cDEFAULT
    winsize 120 45
endif


" Vundle package manager
filetype off
if has("win32")
    set rtp+=~/vimfiles/bundle/Vundle.vim/
    let path='~/vimfiles/bundle'
    call vundle#begin(path)
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

Plugin 'gmarik/Vundle.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'bling/vim-airline'
set laststatus=2  " always show airline
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

call vundle#end()
filetype plugin on


if has("gui_running")	" For general gVim
    " Toggle menu/tool bars
    function s:MenuBar()
	if stridx(&guioptions, 'm') == -1
	    set go+=T go+=m
	else
	    set go-=T go-=m
	endif
    endfunction
    map <silent> <F10> :call <SID>MenuBar()<cr>
    call <SID>MenuBar()
endif
if has("gui_macvim")  " MacVim
    set bg=dark
    colorscheme {{vim_colorscheme}}
    set gfn=Monaco:h12
    set fuopt+=maxvert
    set fuopt+=maxhorz
    set columns=120 lines=50
    set go-=T
    set imd
    set transparency=0
    map t_kD=
endif

syntax on
syntax sync minlines=2000

if !has("gui_running")	" For terminal vims
    if has("win32")
	let s:tty="/dev/pts/0"	" emulate
    elseif $TERM_PROGRAM == 'Apple_Terminal' || $TERM_PROGRAM =~ "iTerm\.app"
	let s:tty="/dev/pts/0"	" emulate
    else
	" The environment variable TTY is set by the shell (see bashrc).
	" Vim's system() function uses redirection and thus the result is
	" 'not a tty' error instead of the actual tty name.
	let s:tty=$TTY
    endif
    set bg=dark
%if vim_colorscheme == "solarized":
    let g:solarized_termcolors=16
    let g:solarized_bold=0
    " Note: solarized recommends use of terminal color setting instead of
    " degraded 256-color mode.
%end
    if s:tty=~"/pts/" && ($TERM=~"-256color" || $TERM=="linux" || $TERM=="screen")
	set t_Co=256
	set term=xterm-256color-italics
	colorscheme {{vim_colorscheme}}
	highlight Comment cterm=italic
    else
	colorscheme default
    endif
endif

set tenc=utf-8 fencs=utf-8,utf-16le,cp949,latin1 fenc=utf-8
set ts=8 sw=4 sts=4 noet tw=0
set hlsearch
set autoindent copyindent nosmartindent nocindent
set wmnu nu nuw=5 ruler
set modeline
set ignorecase smartcase
set scrolloff=2
set iminsert=0 imsearch=0
set backspace=indent,eol,start
filetype plugin on
%if vim_colorscheme == "solarized":
set cursorline
%end

function MyHomeKey()
    let l:column = col('.')
    execute "normal ^"
    if l:column == col('.')
	execute "normal 0"
    endif
endfunction

" Show man pages inside vim like :help command.
source $VIMRUNTIME/ftplugin/man.vim
nmap K :Man <cword><cr>

" Temp directory setup
if exists("$HOME")
    let s:home_dir = substitute($HOME, '[/\\]$', '', '')
    if has("win32")
	let s:home_dir = s:home_dir . '/_vim'
    else
	let s:home_dir = s:home_dir . '/.vim'
    endif
    let &dir = s:home_dir . "/tmp" . &dir
    let &bdir = s:home_dir . "/backup" . &bdir
endif

map j gj
map k gk
map <Down> gj
map <Up> gk
" search by visual block content
vmap // "vy/<C-R>v<cr>
" NOTE: <Home> key may be different on variouse terminals.
imap <silent> [1~ <C-O>:call MyHomeKey()<cr>
map <silent> [1~ :call MyHomeKey()<cr>
" prevent removing indents before # when typing # after indents and smartindent is on (mostly occurs in Python)
inoremap # X#

set mouse=a

" vim: ts=8 sts=4 sw=4 noet
