" Daybreaker's vimrc
" Maintainer: Joongi Kim (me@daybreaker.info)

set nocompatible
if !has("nvim")
  set lazyredraw
endif
scripte utf-8
set enc=utf-8

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

" Functionality plugins
Plugin 'tmux-plugins/vim-tmux-focus-events'
let g:airline_powerline_fonts = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|(__pycache__|build|dist|venv[^\/]*))$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
set laststatus=2  " always show airline
set updatetime=200
let g:signify_vcs_list = ['git', 'hg', 'svn']
Plugin 'mhinz/vim-signify'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-vinegar'
"Plugin 'tpope/vim-surround'
let g:EditorConfig_max_line_indicator = "exceeding"
Plugin 'editorconfig/editorconfig-vim'

" LSP plugins
Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
let g:lsp_diagnostics_enabled = 0  " disable diagnostics support

" Syntax plugins
let g:vim_markdown_folding_disabled = 1
let g:python_slow_sync = 0
let g:python_print_as_function = 1
let g:python_highlight_builtins = 1
let g:python_highlight_builtin_funcs = 1
let g:python_highlight_builtin_objs = 1
let g:python_highlight_builtin_types = 1
let g:python_highlight_class_vars = 1
let g:python_highlight_exceptions = 1
let g:python_highlight_operators = 1
let g:python_highlight_string_format = 1
"Plugin 'nvie/vim-flake8'
"Plugin 'achimnol/python-syntax'
Plugin 'vim-python/python-syntax'
Plugin 'plasticboy/vim-markdown'
Plugin 'ibab/vim-snakemake'
Plugin 'rust-lang/rust.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'JuliaLang/julia-vim'
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
Plugin 'fatih/vim-go'
Plugin 'cespare/vim-toml'
"Plugin 'mileszs/ack.vim'
"Plugin 'jvirtanen/vim-octave'
Plugin 'w0rp/ale'

call vundle#end()
filetype plugin on
set synmaxcol=200
syntax on

if has("gui_running")
  " GUI-specific options
  set cursorline

  " Hide scroll bars always
  set go-=r go-=L

  " Hide toolbar and menu
  set go-=T go-=m

  winsize 122 60
  set columns=122 lines=60

  " IME reset
  inoremap <ESC> <ESC>:set iminsert=0<CR>

  " Windows-specific options
  if has("win32")
    set guifont=Hack:h10:cANSI
    set guifontwide=NanumGothicCoding:h10:cDEFAULT
  endif

  " MacVim-specific options
  if has("gui_macvim")
    set guifont=Menlo\ for\ Powerline:h12
    set transparency=0
  endif

else
  " Terminal-specific options

  set bg=dark
  set nocursorline
  if $TERM =~ "-256color$" || $TERM == "linux"
    if !has("nvim")
      set term=xterm-256color
    endif
    set t_Co=256
    if exists("+termguicolors")
      set termguicolors
    endif
    set t_ut=
    set t_ZH=[3m t_ZR=[23m
    set cursorline
  endif
  highlight Comment gui=italic cterm=italic

endif

" Colorscheme configs.
%if vim_colorscheme == "solarized":
let g:solarized_contrast="high"
%end
colorscheme {{vim_colorscheme}}

" Encodings
set tenc=utf-8
set fencs=utf-8,utf-16le,cp949,latin1
set fenc=utf-8

" Indents
set ts=8 sw=4 sts=4 noet tw={{vim_textwidth}}
set autoindent copyindent nosmartindent nocindent
if exists('+breakindent')
  set breakindent
endif

" Editor View
set wmnu nu nuw=5 ruler
set scrolloff=2

" Per-type settings
au FileType python     setl ts=8 sts=4 sw=4 et fo=croql breakindentopt=shift:4
au FileType ruby       setl ts=8 sts=2 sw=2 et fo=croql
au FileType html       setl ts=8 sts=2 sw=2 et
au FileType javascript setl ts=8 sts=2 sw=2 et
au FileType json       setl ts=8 sts=2 sw=2 et
au FileType markdwon   setl ts=8 sts=2 sw=2 et breakindentopt=shift:2
au FileType tex        setl ts=8 sts=2 sw=2 et
au FileType sh         setl ts=8 sts=2 sw=2 et
au FileType yaml       setl ts=8 sts=2 sw=2 et
au FileType go         setl ts=4 sts=4 sw=4 noet lcs=tab:\ \ ,trail:·

" Per-file settings
set modeline

" Search
set hlsearch
set ignorecase smartcase

" Show man pages inside vim like :help command.
source $VIMRUNTIME/ftplugin/man.vim
nmap K :Man <cword><cr>

" Key bidings and shortcuts
set timeout timeoutlen=3000 ttimeoutlen=100
map j gj
map k gk
map <Down> gj
map <Up> gk
set backspace=indent,eol,start
map <c-l> :bn<CR>
map <c-h> :bN<CR>
map <leader>p :CtrlPBuffer<CR>

" prevent removing indents before # when typing # after indents and smartindent is on (mostly occurs in Python)
inoremap # X#

" enable move-to-beginning/end of the line in insert-mode
inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$

" Mouse support
set mouse=a
if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

" LSP configurations
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  "setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_fold_enabled = 0


" vim: ts=8 sts=2 sw=2 et
