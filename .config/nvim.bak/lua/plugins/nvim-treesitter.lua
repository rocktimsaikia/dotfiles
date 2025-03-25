require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua",
        "vim",
        "typescript",
        "javascript",
        "tsx",
        "python",
        "html",
        "css",
        "go",
        "json",
        "markdown",
        "bash",
        "rust",
        "vimdoc",
    },
    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            set_jumps = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
            },
            include_surrounding_whitespace = true,
        },
    },
})
