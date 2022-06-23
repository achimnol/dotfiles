require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "c", "lua", "javascript", "rust" },
}

require("nvim-tree").setup {
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
}

require('telescope').setup {
}

require('lualine').setup()

require('material').setup {
  disable = {
    background = true,
  },
  italics = {
    comments = true,
  },
  lualine_style = "stealth",
  custom_highlights = {
    Normal = { fg = '#BEC9E8' },
    VertSplit = { fg = '#2A383C' },
    WinSeparator = { fg = '#2A383C' },
    TelescopeBorder = { fg = '#2A383C' },
    NormalFloat = { fg = '#2A383C' },
    FloatBorder = { fg = '#2A383C' },
    CursorLine = { bg = '#11293A', gui = 'underline' },
    Visual = { fg = '#FFFFFF', bg = '#0060DD' },
  },
}

-- vim: set sts=2 sw=2 et
