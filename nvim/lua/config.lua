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
    CocInlayHint = { fg = '#4e5f6d', italic = true },
    TelescopeBorder = { fg = '#2b434a' },
    TelescopePreviewBorder = { fg = '#2b434a' },
    TelescopePromptBorder = { fg = '#2b434a' },
    TelescopeResultsBorder = { fg = '#2b434a' },
    TelescopeMatching = { bg = '#11293a' },
    MatchParen = { fg = 'white', bg = '#4f88b0', bold = true },
  },
}
vim.g.material_style = 'deep ocean'
vim.cmd 'colorscheme material'

require('color-picker').setup()

require('lualine').setup()

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "c", "cpp", "lua", "javascript", "rust" },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    colors = {
        '#ffffff',
        '#ffff00',
        '#ff99ff',
        '#66ffff',
        '#66ff66',
        '#ffcc33',
    },
    termcolors = {
        'White',
        'Yellow',
        'Cyan',
        'Magenta',
        'Green',
        'Brown',
    },
  }
}

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
}

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
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end
})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')

-- vim: set sts=2 sw=2 et
