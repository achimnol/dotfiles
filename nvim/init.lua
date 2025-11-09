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
vim.g.mapleader = ','
vim.g.maplocalleader = ','
if vim.fn.has('nvim') == 1 then
  vim.cmd("let $NVIM_TUI_ENABLE_TRUE_COLOR=1")
end
if vim.fn.has('termguicolors') == 1 then
  vim.o.termguicolors = true
end

-- osc52 clipboard setup
local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

local function read_wezterm_theme()
  local filepath = "/tmp/wezterm-theme"
  local f = io.open(filepath, "r")
  if not f then
    return nil
  end
  local content = f:read("*a")
  f:close()
  return vim.trim(content)
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
  { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000,
    config = function(plugin, opts)
      require("rose-pine").setup({
        styles = { italic = false },
        highlight_groups = {
          Comment = { italic = true },
        },
      })
      vim.cmd.colorscheme("rose-pine")
      -- If the manually configured theme setting is available, use it.
      -- (e.g., for remote SSH terminals)
      local theme = read_wezterm_theme()
      if theme ~= nil then
        vim.cmd(string.format("set bg=%s", theme))
      end
    end
  },
  {
    'f-person/auto-dark-mode.nvim',
    lazy = false,
    priority = 999,
    opts = {
      set_dark_mode = function()
        vim.cmd [[set bg=dark]]
      end,
      set_light_mode = function()
        vim.cmd [[set bg=light]]
      end,
    },
  },
  'nvim-lua/plenary.nvim',
  'nvim-tree/nvim-web-devicons',
  {
    'tpope/vim-vinegar',
    lazy = false,
  },
  {
    'ziontee113/color-picker.nvim',
    config = function(_, opts)
      require('color-picker').setup()
      local keymap_opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<C-c>", "<cmd>PickColor<cr>", keymap_opts)
      vim.keymap.set("i", "<C-c>", "<cmd>PickColorInsert<cr>", keymap_opts)
    end
  },
  'HiPhish/jinja.vim',
  -- {
  --   'HiPhish/rainbow-delimiters.nvim',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  -- },
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
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
        })
    end
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
      manage_folds = true,
      layout = {
        placement = 'edge',
        default_direction = 'left',
      },
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
      vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle! left<CR>')
      vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fa', '<cmd>Telescope aerial<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fc', '<cmd>Telescope commands<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fk', '<cmd>Telescope keymaps<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fr', '<cmd>Telescope registers<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
      vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
      -- vim.keymap.set('n', '<leader>c', '<cmd>PickColor<cr>', { silent = true, noremap = true }) -- conflict with osc52
      vim.keymap.set('i', '<C-c>', '<cmd>PickColorInsert<cr>', { silent = true, noremap = true })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "python",
        "go",
        "gomod",
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
        "rst",  -- unstable; infinite recursion issue with git-merge-conflicted rst files
        "gitcommit",
        "diff",        -- dependency of gitcommit
        "git_rebase",  -- dependency of gitcommit
      },
      rainbow = {
        enable = false,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          scope_incremental = '<CR>',
          node_incremental = '<TAB>',
          node_decremental = '<S-TAB>',
        },
      },
    },
    config = function(plugin, opts)
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
    config = function(plugin, opts)
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

      function _G.ShowDocs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end
      vim.keymap.set("n", "K", '<CMD>lua _G.ShowDocs()<CR>', { silent = true })
      -- To hide it by default, put `inlayHint.display = false` in ~/.config/nvim/coc-settings.json
      vim.api.nvim_set_keymap('n', '<leader>ti', '<cmd>CocCommand document.toggleInlayHint<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
      indent = { char = '┆' },
      scope = { show_start = false, show_end = false },
      -- use_treesitter = true,
      -- max_indent_increase = 1,
    },
  },
  {
    'ojroques/nvim-osc52',
    config = function(_, opts)
      local plugin = require('osc52')
      plugin.setup(opts)
      vim.keymap.set('n', '<leader>c', plugin.copy_operator, {expr = true})
      vim.keymap.set('v', '<leader>c', plugin.copy_visual)
    end
  },
  {
    "karb94/neoscroll.nvim",
    config = function ()
      local neoscroll = require('neoscroll')
      neoscroll.setup {
        easing_function = 'cubic',
      }
      local keymap = {
        ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 100 }) end,
        ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 100 }) end,
        ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 100 }) end,
        ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 100 }) end,
        ["<PageUp>"] = function() neoscroll.ctrl_b({ duration = 100 }) end,
        ["<PageDown>"] = function() neoscroll.ctrl_f({ duration = 100 }) end,
        ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 50 }) end,
        ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 50 }) end,
      }
      local modes = { 'n', 'v', 'x' }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end
    end
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function ()
      require('toggleterm').setup {
        open_mapping = [[<c-\>]],
      }
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end
      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function(plugin, opts)
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})
          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk)
          map('n', '<leader>hr', gs.reset_hunk)
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end
  },
})

-- vim: sts=2 sw=2 et
