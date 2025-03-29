-- Abbreviations
-- Words
vim.cmd("iabbrev teh the")
vim.cmd("iabbrev recieved received")
vim.cmd("iabbrev adn and")

-- Miscellaneous
vim.cmd("iabbrev em —")
vim.cmd("iabbrev arr →")
vim.cmd("iabbrev yr " .. os.date("%Y"))

-- Personal
vim.cmd("iabbrev @@ rocktimthedev@gmail.com")
vim.cmd("iabbrev sig Rocktim Saikia")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.iskeyword:append("-")
vim.opt.hidden = true -- Enables switching between buffers without requiring changes to be saved first.

-- KEY MAPPINGS --

-- Diagnostics
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>s", "<CMD>w<CR>")
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Clipboard
vim.keymap.set("v", "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>wy", 'viw"+y', opts)

-- Disable arrow keys
vim.keymap.set("", "<up>", "<nop>", opts)
vim.keymap.set("", "<down>", "<nop>", opts)
vim.keymap.set("", "<left>", "<nop>", opts)
vim.keymap.set("", "<right>", "<nop>", opts)

-- Map Esc to jj
vim.keymap.set("i", "jj", "<Esc>", opts)

-- Clear search highlighting with <leader> and c
vim.keymap.set("n", "<leader>c", ":nohl<CR>", opts)

-- Split remapping
vim.keymap.set("n", ",s", ":vsplit<CR>", opts)
vim.keymap.set("n", ",d", ":split<CR>", opts)

-- Move around splits using Ctrl + {h,j,k,l}
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- add your plugins here
        {
            -- Snippet engine
            "L3MON4D3/LuaSnip",
            version = "v2.3.0",
            dependencies = { "rafamadriz/friendly-snippets" },
            build = "make install_jsregexp",
            config = function()
                -- load my custom snippets
                require("luasnip.loaders.from_vscode").lazy_load({
                    paths = { vim.fn.expand("~/.config/nvim/snippets") },
                })

                -- Expand keymap for snippets
                local ls = require("luasnip")
                vim.keymap.set({ "i" }, "<C-K>", function()
                    ls.expand()
                end, { silent = true })
            end,
        },

        -- Auto completion x Snippets x LSP
        {
            "hrsh7th/nvim-cmp",
            config = function()
                require("cmp").setup({
                    snippet = {
                        expand = function(args)
                            require("luasnip").lsp_expand(args.body)
                        end,
                    },

                    -- Add the completion sources here
                    sources = {
                        { name = "luasnip" },
                        { name = "buffer" },
                        { name = "nvim_lsp" },
                    },
                })
            end,
        },
        { "saadparwaiz1/cmp_luasnip" }, -- Snippets source for completion
        { "hrsh7th/cmp-buffer" }, -- Buffer source for completion
        { "hrsh7th/cmp-nvim-lsp" }, -- LSP source for completion
        {
            "neovim/nvim-lspconfig",
            config = function()
                local lsp = require("lspconfig")

                -- Use an on_attach function to only map the following keys
                -- after the language server attches to the current buffer
                local on_attach = function(client, bufnr)
                    local bufopts = { noremap = true, silent = true, buffer = bufnr }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
                    vim.keymap.set("n", "<space>t", vim.lsp.buf.type_definition, bufopts)
                    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
                end

                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                -- LSP clients
                lsp.pyright.setup({ on_attach = on_attach, capabilities = capabilities })
                lsp.ts_ls.setup({ on_attach = on_attach, capabilities = capabilities })
                lsp.elmls.setup({ on_attach = on_attach, capabilities = capabilities, filetypes = { "elm" } })
                lsp.tailwindcss.setup({ on_attach = on_attach, capabilities = capabilities })
            end,
        },

        {
            "nvim-telescope/telescope.nvim",
            branch = "master",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                require("telescope").setup({
                    defaults = {
                        file_ignore_patterns = {
                            "web%-sdk",
                            "storybook",
                            "web%-static",
                            "polr",
                            "node_modules",
                            "web/tests",
                            "web/public",
                            ".git",
                            "**/migrations",
                            "api/tests",
                            "api/static_media",
                            "build",
                            ".pytest_cache",
                            ".github",
                        },
                        vimgrep_arguments = {
                            "rg",
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case",
                            "-g",
                            "!web-sdk/*",
                            "-g",
                            "!storybook/*",
                            "-g",
                            "!web-static/*",
                            "-g",
                            "!polr/*",
                            "-g",
                            "!node_modules/*",
                            "-g",
                            "!web/tests/*",
                            "-g",
                            "!web/public/*",
                            "-g",
                            "!.git/*",
                            "-g",
                            "!**/migrations/*",
                            "-g",
                            "!api/tests/*",
                            "-g",
                            "!api/static_media/*",
                            "-g",
                            "!build/*",
                            "-g",
                            "!.pytest_cache/*",
                            "-g",
                            "!.github/*",
                            "-g",
                            "!pnpm-lock.yaml",
                        },
                    },
                })
                local builtin = require("telescope.builtin")
                vim.keymap.set("n", "<leader>ff", builtin.find_files)
                vim.keymap.set("n", "<leader>fg", builtin.live_grep)
                vim.keymap.set("n", "<leader>fb", builtin.buffers)
                vim.keymap.set("n", "<leader>fh", builtin.help_tags)
                vim.keymap.set("n", "<leader>rr", builtin.lsp_references)
                -- vim.keymap.set("n", "<leader>gd", builtin.lsp_definations)
                -- vim.keymap.set("n", "<leader>tt", builtin.lsp_type_definitions)
                vim.keymap.set("n", "<leader>gc", builtin.git_bcommits)
                vim.keymap.set("v", "<leader>gc", builtin.git_bcommits_range)
                vim.keymap.set("n", "<leader>gs", builtin.git_status)
                vim.keymap.set("n", "<leader>gss", builtin.git_stash)
                vim.keymap.set("n", "<leader>gb", builtin.git_branches)
            end,
        },

        {
            "stevearc/conform.nvim",
            config = function()
                conform = require("conform")

                function should_use_biome(bufnr)
                    if conform.get_formatter_info("biome", bufnr).available then
                        return { "biome", "biome-organize-imports" }
                    else
                        return { "prettierd" }
                    end
                end

                conform.setup({
                    format_on_save = {
                        timeout_ms = 5000,
                        lsp_fallback = true,
                    },
                    formatters = {
                        black = {
                            prepend_args = { "--fast" },
                        },
                    },
                    formatters_by_ft = {
                        lua = { "stylua" },
                        python = { "black" },
                        html = { "prettierd" },
                        javascript = should_use_biome,
                        typescript = should_use_biome,
                        javascriptreact = should_use_biome,
                        typescriptreact = should_use_biome,
                        json = { "prettierd" },
                        jsonc = { "prettierd" },
                        css = { "prettierd" },
                        sh = { "shellharden" },
                        go = { "gofmt", "golines" },
                        htmldjango = nil,
                    },
                })
            end,
        },

        {
            -- Edit x Add custom snippets
            "chrisgrieser/nvim-scissors",
            dependencies = "nvim-telescope/telescope.nvim",
            opts = {
                snippetDir = vim.fn.expand("~/.config/nvim/snippets"),
            },
            config = function()
                -- Keys maps for editing and adding snippets
                vim.keymap.set("n", "<leader>se", function()
                    require("scissors").editSnippet()
                end, { desc = "Snippet: Edit" })

                -- when used in visual mode, prefills the selection as snippet body
                vim.keymap.set({ "n", "x" }, "<leader>sa", function()
                    require("scissors").addNewSnippet()
                end, { desc = "Snippet: Add" })
            end,
        },

        {
            "stevearc/oil.nvim",
            ---@module 'oil'
            ---@type oil.SetupOpts
            opts = {
                view_options = {
                    show_hidden = true,
                },
                columns = {
                    "icon",
                },
            },
            cmd = { "Oil" },
            keys = {
                { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
                {
                    "^",
                    function()
                        require("oil").open(vim.fn.getcwd())
                    end,
                    desc = "Open cwd",
                },
            },
            -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
            lazy = false,
        },

        {
            "echasnovski/mini.icons",
            opts = {},
            cond = function()
                return vim.g.have_nerd_font == true
            end,
        },

        {
            -- Bookmark manager
            "otavioschwanck/arrow.nvim",
            opts = {
                separate_by_branch = true,
                show_icons = false,
                leader_key = ";", -- All marked file mappings
                buffer_leader_key = "m", -- Per buffer mappings
            },
        },

        { "tpope/vim-surround" },
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            config = true,
        },

        {
            "Exafunction/codeium.vim",
            event = "BufEnter",
            config = function()
                vim.g.codeium_filetypes = {
                    ["sh"] = false,
                    [""] = false,
                }
            end,
        },

        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            opts = {
                ensure_installed = { "lua", "python", "javascript", "typescript", "html", "css", "json", "elm" },
                highlight = { enable = true, additional_vim_regex_highlighting = false },
            },
        },

        {
            "rebelot/kanagawa.nvim",
            config = function()
                vim.cmd("colorscheme kanagawa-wave")
            end,
        },

        {
            "stevearc/resession.nvim",
            config = function()
                local resession = require("resession")
                resession.setup()
                -- Resession does NOTHING automagically, so we have to set up some keymaps
                vim.keymap.set("n", "<leader>ss", resession.save)
                vim.keymap.set("n", "<leader>sl", resession.load)
                vim.keymap.set("n", "<leader>sd", resession.delete)
                -- Automatically save a session when you exit Neovim
                vim.api.nvim_create_autocmd("VimLeavePre", {
                    callback = function()
                        -- Always save a special session named "last"
                        resession.save("last")
                    end,
                })
            end,
        },

        { "shortcuts/no-neck-pain.nvim", version = "*" },

        {
            "f-person/git-blame.nvim",
            event = "VeryLazy",
            opts = {
                enabled = true, -- if you want to enable the plugin
            },
        },
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
