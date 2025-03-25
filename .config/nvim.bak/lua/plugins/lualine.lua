require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "gruvbox-material",
        -- theme = "tokyonight",
        -- theme = "everblush",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            "branch",
            "diagnostics",
        },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype", "%L" }, -- Total line numbers
        lualine_y = {},
        lualine_z = {
            function()
                return vim.fn.ObsessionStatus("Ob", "X")
            end,
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
})
