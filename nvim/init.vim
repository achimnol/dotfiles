set enc=utf-8
set sts=4 sw=4 et
set autoindent copyindent
set nu cursorline scrolloff=2

if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

if (has("termguicolors"))
 set termguicolors
endif

call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'marko-cerovac/material.nvim'
Plug 'gpanders/editorconfig.nvim'
call plug#end()

" Load lua-based configurations
lua require('config')

syntax enable
let g:material_style = "deep ocean"
colorscheme material

nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap - <cmd>NvimTreeToggle<cr>
