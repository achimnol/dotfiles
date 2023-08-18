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
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<C-c>", "<cmd>PickColor<cr>", opts)
      vim.keymap.set("i", "<C-c>", "<cmd>PickColorInsert<cr>", opts)
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
    "folke/neoconf.nvim",
    lazy = false,
    config = true,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      null_ls.setup({
        sources = {
          -- formatting
          null_ls.builtins.formatting.ruff.with({
            prefer_local = "./dist/export/python/virtualenvs/ruff/3.11.4/bin",
            -- command = "/home/joongi/bai-edge/dist/export/python/virtualenvs/ruff/3.11.4/bin",
          }),
          null_ls.builtins.formatting.black.with({
            prefer_local = "./dist/export/python/virtualenvs/black/3.11.4/bin",
            -- command = "/home/joongi/bai-edge/dist/export/python/virtualenvs/black/3.11.4/bin",
          }),
          -- diagnostics
          null_ls.builtins.diagnostics.ruff,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = true,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    config = true,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require('cmp')

      cmp.setup({
        completion = {
          autocomplete = false
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<s-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<c-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "folke/neoconf.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts = {},
    config = function(opts)
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd('CursorHold', { callback = function() vim.lsp.buf.document_highlight() end })
          vim.api.nvim_create_autocmd('CursorHoldI', { callback = function() vim.lsp.buf.document_highlight() end })
          vim.api.nvim_create_autocmd('CursorMoved', { callback = function() vim.lsp.buf.clear_references() end })
        end
      end

      local lspconfig = require("lspconfig")
      lspconfig.pyright.setup { on_attach = on_attach }
      lspconfig.rust_analyzer.setup { on_attach = on_attach }
      lspconfig.ruff_lsp.setup { on_attach = on_attach }
      lspconfig.lua_ls.setup { on_attach = on_attach }
      lspconfig.tailwindcss.setup { on_attach = on_attach }

      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      -- vim.api.nvim_create_autocmd('BufWritePre',
      --   { callback = function() vim.lsp.buf.format({ async = false }) end })
      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          -- vim.keymap.set('n', '<space>wl', function()
          --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- end, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
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
})

-- vim: sts=2 sw=2 et
