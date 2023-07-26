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
    "m4xshen/autoclose.nvim",
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
}

require("lazy").setup(plugins)
require("mason").setup()
require("catppuccin").setup({
    flavor = "mocha",
    transparent_background = true,
    show_end_of_buffer = false,
    term_colors = true,
})
require("autoclose").setup()
require("lualine").setup()
require("barbar").setup()
require("trouble").setup()

--- oil.nvim ------------------------------------------------------------------
require("oil").setup()

vim.keymap.set("n", "-", require("oil").open,
{ desc = "Open parent directory" })

-- Set up lsp-zero. -----------------------------------------------------------
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
-------------------------------------------------------------------------------

-- The all important colorscheme
vim.cmd.colorscheme "catppuccin"
