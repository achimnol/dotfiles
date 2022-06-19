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

require('onedark').setup {
  style = 'cool',
  transparent = true,
}
require('onedark').load()
