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
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            "petertriho/cmp-git"
        }

    },
    {
        'junnplus/lsp-setup.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            {
                "williamboman/mason.nvim",
                -- :MasonUpdate updates registry contents
                build = ":MasonUpdate"
            },
            'williamboman/mason-lspconfig.nvim', -- optional
        },
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

-- Set up nvim-cmp. -----------------------------------------------------------
local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        -- Accept currently selected item. Set `select` to `false` to only
        -- confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        -- You can specify the `git` source if [you were installed it]
        -- (https://github.com/petertriho/cmp-git).
        { name = 'git' },
    },
    {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`,
-- this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`,
-- this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['lua_ls'].setup {
    capabilities = capabilities
}
require('lspconfig')['yamlls'].setup {
    capabilities = capabilities
}
require('lspconfig')['pylsp'].setup {
    capabilities = capabilities
}
require('lspconfig')['ltex'].setup {
    capabilities = capabilities
}
require('lspconfig')['marksman'].setup {
    capabilities = capabilities
}

-------------------------------------------------------------------------------

-- The all important colorscheme
vim.cmd.colorscheme "catppuccin"
