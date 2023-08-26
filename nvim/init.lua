-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic Vim options
vim.o.bg = 'dark'
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

local function apply_ripgreprc(config_table)
  local ripgrep_config_path = vim.fn.getcwd() .. "/.ripgreprc"
  local f = io.open(ripgrep_config_path, "r")
  if f == nil then
    return
  end
  for line in f:lines() do
    if not line:match("^%s*#") and not line:match("^%s*$") then
      table.insert(config_table, line)
    end
  end
  f:close()
end

local ripgrep_config = {
  "rg",
  "--color=never",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--column",
  "--smart-case",
}
apply_ripgreprc(ripgrep_config)

require("lazy").setup({
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup({
        groups = {
          all = {
            CursorLine = { bg = '#21262d' },
            CocInlayHint = { fg = '#38404d', italic = true },
            CocHighlightText = { bg = '#38404d' },
            AerialLine = { bg = '#38404d' },
          },
        },
        options = {
          transparent = true,
          styles = {
            comments = 'italic',
          },
        }
      })
      vim.cmd 'colorscheme github_dark'
    end
  },
  'nvim-lua/plenary.nvim',
  'nvim-tree/nvim-web-devicons',
  {
    'tpope/vim-vinegar',
    lazy = false,
  },
  {
    'ziontee113/color-picker.nvim',
    config = function()
      require('color-picker').setup()
      local keymap_opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<C-c>", "<cmd>PickColor<cr>", keymap_opts)
      vim.keymap.set("i", "<C-c>", "<cmd>PickColorInsert<cr>", keymap_opts)
    end
  },
  'HiPhish/jinja.vim',
  {
    'HiPhish/nvim-ts-rainbow2',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  'pwntester/octo.nvim',
  {
    'nvim-lualine/lualine.nvim',
    opts = {
    },
    dependencies = {
      'projekt0n/github-nvim-theme',
      'nvim-tree/nvim-web-devicons',
    },
    event = "VeryLazy",
  },
  {
    'stevearc/aerial.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope.nvim',
    },
    cmd = { "AerialToggle" },
    opts = {
      attach_mode = 'global',
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    },
    config = function(plugin, opts)
      require('aerial').setup(opts)
      require('telescope').load_extension('aerial')
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'ziontee113/color-picker.nvim',
    },
    opts = {
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
      vimgrep_arguments = ripgrep_config,
    },
    init = function()
      require('telescope').load_extension('aerial')
      vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
      vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fa', '<cmd>Telescope aerial<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fr', '<cmd>Telescope registers<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>c', '<cmd>PickColor<cr>', { silent = true, noremap = true })
      vim.keymap.set('i', '<C-c>', '<cmd>PickColorInsert<cr>', { silent = true, noremap = true })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "python",
        "c",
        "cpp",
        "lua",
        "javascript",
        "typescript",
        "rust",
        "bash",
        "json",
        "toml",
        "yaml",
        "css",
        "html",
        "markdown",
        --- "rst",  -- unstable; infinite recursion issue with git-merge-conflicted rst files
        "gitcommit",
      },
      rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      },
      indent = {
        enable = true,
      },
    },
    config = function(opts)
      -- ref: https://www.lazyvim.org/plugins/treesitter
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'neoclide/coc.nvim', branch = 'release',
    lazy = false,
    config = function(opts)
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
      -- CoC: Show code actions
      vim.keymap.set('n', '<leader>ac', '<Plug>(coc-codeaction-cursor)')
      vim.keymap.set('n', '<leader>as', '<Plug>(coc-codeaction-source)')
      -- CoC: Tab-based auto completion
      vim.keymap.set('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<CR>"', { silent = true, noremap = true, expr = true })
      vim.keymap.set('i', '<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : "<Tab>"', { silent = true, noremap = true, expr = true })
      vim.keymap.set('i', '<S-Tab>', 'coc#pum#visible() ? coc#pum#prev(1) : "<S-Tab>"', { silent = true, noremap = true, expr = true })

      -- CoC: Formatting selected code.
      vim.api.nvim_create_user_command('Format',
        "call CocActionAsync('format')",
        { nargs = 0 }
      )
      vim.keymap.set({'v', 'n'}, '<leader>sf', '<Plug>(coc-format-selected)')

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
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┆',
      show_current_context = true,
      show_current_context_start = false,
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      max_indent_increase = 1,
    },
  },
  {
    'ojroques/nvim-osc52',
    config = function(opts)
      local plugin = require('osc52')
      plugin.setup(opts)
      vim.keymap.set('n', '<leader>c', plugin.copy_operator, {expr = true})
      vim.keymap.set('v', '<leader>c', plugin.copy_visual)
    end
  },
})

-- vim: sts=2 sw=2 et
