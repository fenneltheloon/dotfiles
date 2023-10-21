local TAB_WIDTH = 4
local set = vim.opt -- set options

set.nu = true
set.rnu = true
set.tabstop = TAB_WIDTH
set.shiftwidth = TAB_WIDTH
set.expandtab = true
set.fileencoding = "utf-8"
set.clipboard = "unnamedplus"
set.ignorecase = true
set.smartindent = true
set.termguicolors = true
set.updatetime = 300
set.scrolloff = 8
set.sidescrolloff = 8
set.cc = "80"

-- set mapleader
vim.g.mapleader = " "

vim.opt.completeopt = {"menu", "menuone", "noselect"}

vim.filetype.add({ extension = {typ = "typst"}})

-- bootstrap lazy.nvim
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

local plugins = {
    "folke/which-key.nvim",
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
                -- LSP Support
                {'neovim/nvim-lspconfig'},             -- Required
                {                                      -- Optional
                    'williamboman/mason.nvim',
                    build = function()
                        pcall(vim.api.nvim_command, 'MasonUpdate')
                    end,
                },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    "nvim-lualine/lualine.nvim",
    {
        "iamcco/markdown-preview.nvim",
        ft = "md",
        run = function ()
            vim.fn["mkdp#util#install"]()
        end,
        event="BufRead",
    },
    {
        "romgrk/barbar.nvim",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        init = function ()
            vim.g.barbar_auto_setup = false
        end,
        opts = {
            -- Configure barbar here
        }
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        'kaarmu/typst.vim',
        ft = 'typst',
        lazy=false,
    },
}

require("lazy").setup(plugins)
require("mason").setup({})
require("catppuccin").setup({
    flavor = "mocha",
    transparent_background = true,
    show_end_of_buffer = false,
    term_colors = true,
})
require("lualine").setup()
require("barbar").setup()
require("trouble").setup()

--- oil.nvim ------------------------------------------------------------------
require("oil").setup()

vim.keymap.set("n", "-", require("oil").open,
{desc = "Open parent directory" })

-- Set up lsp-zero. -----------------------------------------------------------

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
  },
})

lsp_zero.setup()

require('lspconfig').typst_lsp.setup({
    settings = {
        exportPdf = "onSave" -- Choose onType, onSave, or never.
        -- serverPath = "" -- Normally, there is no need to uncomment.
    }
})

require('lspconfig').ltex.setup({
    settings = {
        ltex ={
            filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex",
            "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd", "typst" },
        },
    },
})

lsp_zero.setup_servers({'lua_ls', 'rust_analyzer', 'pylsp'})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
cmp.setup({
  sources = {
    {name = 'nvim_lsp'}
  },
  mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

-------------------------------------------------------------------------------

-- The all important colorscheme
vim.cmd.colorscheme "catppuccin"
