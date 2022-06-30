require('material').setup {
  disable = {
    background = true,
  },
  italics = {
    comments = true,
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
    TelescopeBorder = { fg = '#2b434a' },
    TelescopePreviewBorder = { fg = '#2b434a' },
    TelescopePromptBorder = { fg = '#2b434a' },
    TelescopeResultsBorder = { fg = '#2b434a' },
    TelescopeMatching = { bg = '#11293a' },
  },
}
vim.g.material_style = 'deep ocean'
vim.cmd 'colorscheme material'

require('color-picker').setup()

require('lualine').setup()

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "c", "lua", "javascript", "rust" },
}

require('telescope').setup()

require('nvim-tree').setup {
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
}

-- vim: set sts=2 sw=2 et
