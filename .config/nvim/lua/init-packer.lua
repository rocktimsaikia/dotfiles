vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init-packer.lua source <afile> | PackerCompile
    autocmd BufWritePost init-packer.lua source <afile> | PackerInstall
  augroup end
]])

-- Pluggins
return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- tpope's stuff
    use("tpope/vim-surround")
    use("tpope/vim-commentary") -- Commenting made easy
    use("tpope/vim-unimpaired") -- Using for only :cnext and :cprevious
    use("tpope/vim-capslock")
    use("tpope/vim-obsession")

    use("nvim-lua/plenary.nvim")
    use("wellle/targets.vim") -- provides additional text objects
    use("nvim-lualine/lualine.nvim")
    use("jiangmiao/auto-pairs")

    use({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    })

    -- Color themes
    -- use({
    --     "sainnhe/gruvbox-material",
    --     config = function()
    --         vim.g.gruvbox_material_background = "hard"
    --         vim.g.gruvbox_material_better_performance = 1
    --         vim.cmd("colorscheme gruvbox-material")
    --     end,
    -- })

    use({
        "folke/tokyonight.nvim",
        config = function()
            vim.cmd("colorscheme tokyonight-night")
            vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
            vim.cmd([[hi NvimTreeNormalNC guibg=NONE ctermbg=NONE]])
            -- vim.cmd([[hi NvimTreeEndOfBuffer guibg=NONE ctermbg=NONE]])
        end,
    })

    use({
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = {
            "nvim-telescope/telescope-github.nvim",
        },
    })

    -- Git stuff
    use("f-person/git-blame.nvim")

    -- LSP and autocompletion stuff
    use("neovim/nvim-lspconfig") -- configurations for Nvim LSP
    use("hrsh7th/nvim-cmp") -- Autocompletion plugin
    use("hrsh7th/cmp-nvim-lsp") -- neovim builtin LSP client completion source for nvim-cmp
    use("L3MON4D3/LuaSnip") -- Snippet engine for neovim
    use("saadparwaiz1/cmp_luasnip") -- luasnip completion source for nvim-cmp
    use("jose-elias-alvarez/null-ls.nvim") -- Formatting & linting stuff

    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
    })

    -- File explorer | looking for alternatives
    use({
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons", -- optional, for file icons
        },
        tag = "nightly", -- optional, updated every week. (see issue #1193)
    })

    -- Auto close and auto rename html tag
    use({
        "windwp/nvim-ts-autotag",
        require("nvim-treesitter.configs").setup({
            autotag = {
                enable = true,
            },
        }),
    })

    -- Generate function annotations
    use({
        "danymat/neogen",
        config = function()
            require("neogen").setup({})
        end,
    })

    -- Discord rich presence
    use("andweeb/presence.nvim")

    -- Peek lines as you type the line number
    use({
        "nacro90/numb.nvim",
        config = function()
            require("numb").setup()
        end,
    })

    use("AndrewRadev/splitjoin.vim") -- Split oneliner to multiliner
    use("nvim-treesitter/nvim-treesitter-textobjects") -- Only using @function.inner @function.outer
    use("rhysd/git-messenger.vim") -- Show commit history for the current line

    -- Useful when focus coding
    use({
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup({})
        end,
    })

    use({
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup({})
        end,
    })

    use("JoosepAlviste/nvim-ts-context-commentstring")

    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    })

    use("lukas-reineke/indent-blankline.nvim")

    use({
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup()
        end,
    })

    use("github/copilot.vim")

    -- Extends the default increment/decrement operators
    use({
        "nat-418/boole.nvim",
        config = function()
            require("boole").setup({
                mappings = {
                    increment = "<C-a>",
                    decrement = "<C-x>",
                },
            })
        end,
    })
    -- Git commit browser
    use({
        "junegunn/gv.vim",
        requires = { "tpope/vim-fugitive" },
    })

    -- Better cmdline UI
    use({
        "folke/noice.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
        },
    })

    -- Mark files and toggle inbetween them fast
    use("cbochs/grapple.nvim")

    -- Fancy cursor
    use({
        "gen740/SmoothCursor.nvim",
        config = function()
            require("smoothcursor").setup({})
        end,
    })
end)
