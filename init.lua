vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.termguicolors = true

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({ transparent_mode = true })
      vim.cmd("colorscheme gruvbox")
    end,
  },

  -- {
  --   "echasnovski/mini.base16",
  --   priority = 1000,
  --   config = function()
  --     require("mini.base16").setup({
  --       palette = require('mini.base16').mini_palette('#112641', '#e2e98f', 75)
  --     })
  --   end,
  -- },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { theme = "auto" },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>" },
    },
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  { "ThePrimeagen/vim-be-good" },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({ current_line_blame = true })
      vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next Git Hunk" })
      vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Prev Git Hunk" })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript", "typescript", "tsx", "html", "css" },
        highlight = { enable = true },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        desc = "Format file",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("biome", { 
        capabilities = capabilities 
      })
      vim.lsp.enable("biome")
      
      vim.lsp.config("vtsls", { 
        capabilities = capabilities,
        settings = {
          typescript = {
            suggest = { autoImports = true },
            updateImportsOnFileMove = { enabled = "always" },
            preferences = {
              importModuleSpecifier = "non-relative",
            },
          },
          javascript = {
            suggest = { autoImports = true },
            updateImportsOnFileMove = { enabled = "always" },
            preferences = {
              importModuleSpecifier = "non-relative",
            },
          },
        },
      })
      vim.lsp.enable("vtsls")
      
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Diagnostics" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
      
      vim.keymap.set("n", "<leader>co", "<cmd>VtslsOrganizeImports<CR>", { desc = "Organize Imports" })
      vim.keymap.set("n", "<leader>ci", "<cmd>VtslsAddMissingImports<CR>", { desc = "Add Missing Imports" })
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    },
  },
})

