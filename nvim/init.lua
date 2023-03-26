-- Basic Vim options
vim.o.enc = 'utf-8'
vim.o.sts = 4
vim.o.sw = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.nu = true
vim.o.cursorline = true
vim.o.scrolloff = 2
vim.o.exrc = true
vim.o.secure = true
vim.o.updatetime = 300
vim.o.modeline = true
if vim.fn.has('nvim') == 1 then
  vim.cmd("let $NVIM_TUI_ENABLE_TRUE_COLOR=1")
end
if vim.fn.has('termguicolors') == 1 then
  vim.o.termguicolors = true
end


-- Plugin Loader
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons' -- optional, for file icons
-- Plug 'kyazdani42/nvim-tree.lua'
Plug 'tpope/vim-vinegar'
Plug 'nvim-lualine/lualine.nvim'
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = vim.fn['TSUpdate'] })
Plug 'marko-cerovac/material.nvim'
Plug 'gpanders/editorconfig.nvim'
Plug 'ziontee113/color-picker.nvim'
-- Plug 'dense-analysis/ale'
Plug('neoclide/coc.nvim', { branch = 'release' })
Plug 'HiPhish/jinja.vim'
Plug 'HiPhish/nvim-ts-rainbow2'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'stevearc/aerial.nvim'
Plug 'pwntester/octo.nvim'
vim.call('plug#end')


require('material').setup {
  disable = {
    background = true,
  },
  plugins = {
    -- "nvim-tree",
    "telescope",
  },
  styles = {
    comments = { italic = true },
  },
  lualine_style = "stealth",
  custom_highlights = {
    Normal = { fg = '#bec9e8' },
    VertSplit = { fg = '#2b434a' },
    WinSeparator = { fg = '#2b434a' },
    NormalFloat = { fg = '#2b434a' },
    FloatBorder = { fg = '#2b434a', bg = 'NONE' },
    CursorLine = { bg = '#11293a', },
    Visual = { fg = '#ffffff', bg = '#0060dd' },
    Search = { fg = '#ffffff', bg = '#1b5d7e' },
    Comment = { fg = '#4e5f6d', italic = true },
    CocInlayHint = { fg = '#2b434a', italic = true },
    CocHighlightText = { bg = '#1c4865' },
    TelescopeBorder = { fg = '#2b434a' },
    TelescopePreviewBorder = { fg = '#2b434a' },
    TelescopePromptBorder = { fg = '#2b434a' },
    TelescopeResultsBorder = { fg = '#2b434a' },
    TelescopeMatching = { bg = '#11293a' },
    MatchParen = { fg = 'white', bg = '#4f88b0', bold = true },
    TSRainbowRed    = { fg = '#ffffff' },
    TSRainbowYellow = { fg = '#ffff00' },
    TSRainbowBlue   = { fg = '#ff99ff' },
    TSRainbowOrange = { fg = '#66ffff' },
    TSRainbowGreen  = { fg = '#66ff66' },
    TSRainbowViolet = { fg = '#ffcc33' },
    TSRainbowCyan   = { fg = '#ff6600' },
  },
}
vim.g.material_style = 'deep ocean'
vim.cmd 'colorscheme material'

require('color-picker').setup()

require('lualine').setup()

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "c", "cpp", "lua", "javascript", "typescript", "rust", "bash", "json", "toml", "yaml", "css", "html", "markdown", "rst" },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
  }
}

require('telescope').load_extension('aerial')
require('telescope').setup {
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
      },
    },
  },
  extensions = {
    aerial = {
      show_nesting = {
        ['_'] = false,
        json = true,
        yaml = true,
      },
    },
  },
}
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fa', '<cmd>Telescope aerial<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope registers<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
vim.keymap.set('n', '<leader>c', '<cmd>PickColor<cr>', { silent = true, noremap = true })
vim.keymap.set('i', '<C-c>', '<cmd>PickColorInsert<cr>', { silent = true, noremap = true })

require('indent_blankline').setup {
  char = '┆',
  show_current_context = true,
  show_current_context_start = false,
  show_trailing_blankline_indent = false,
  use_treesitter = true,
  max_indent_increase = 1,
}

require('aerial').setup({
  on_attach = function(bufnr)
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end
})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')

require('octo').setup()

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
vim.keymap.set('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
vim.keymap.set('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })
-- CoC: GoTo code navigation.
vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })
-- CoC: Symbol renaming.
vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)')
-- CoC: Formatting selected code.
vim.keymap.set({'x', 'n'}, '<leader>ff', '<Plug>(coc-format-selected)')
vim.keymap.set('n', '<leader>ff', '<Plug>(coc-format-selected)')
-- CoC: Tab-based auto completion
vim.keymap.set('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<CR>"', { silent = true, noremap = true, expr = true })
vim.keymap.set('i', '<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : "<Tab>"', { silent = true, noremap = true, expr = true })
vim.keymap.set('i', '<S-Tab>', 'coc#pum#visible() ? coc#pum#prev(1) : "<S-Tab>"', { silent = true, noremap = true, expr = true })

function _G.show_docs()
  local cw = vim.fn.expand('<cword>')
  if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
    vim.api.nvim_command('h ' .. cw)
  elseif vim.api.nvim_eval('coc#rpc#ready()') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
  end
end
vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

vim.api.nvim_create_user_command('Format',
  "call CocActionAsync('format')",
  { nargs = 0 }
)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {  -- Need to run `:CocInstall coc-highlight`
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
})
vim.api.nvim_create_autocmd('BufReadCmd', {
  group = "CocGroup",
  pattern = {'*.whl'},
  command = 'call zip#Browse(expand("<amatch>"))'
})

-- vim: sts=2 sw=2 et
