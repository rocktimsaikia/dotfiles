local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = "100" })
    end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
    pattern = "",
    command = ":%s/\\s\\+$//e",
})

-- Don't auto comment on new lines while pressing enter key
autocmd("BufEnter", {
    pattern = "",
    command = "set fo-=c fo-=r fo-=o",
})

-- Terminal settings:
-- Open a Terminal on the right tab
autocmd("CmdlineEnter", {
    command = "command! Term :botright vsplit term://$SHELL",
})

-- Enter insert mode when switching to terminal
autocmd("TermOpen", {
    command = "setlocal listchars= nonumber norelativenumber nocursorline",
})

autocmd("TermOpen", {
    pattern = "",
    command = "startinsert",
})

-- Close terminal buffer on process exit
autocmd("BufLeave", {
    pattern = "term://*",
    command = "stopinsert",
})

autocmd("LspAttach", {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local current_user = vim.fn.system("whoami")
        current_user = current_user:gsub("%s+", "")

        if current_user == "rocktim" then
            if vim.bo.filetype == "python" then
                vim.cmd("PyrightOrganizeImports")
            end
            if vim.bo.filetype == "typescript" then
                vim.cmd("OrganizeImports")
            end
            if vim.bo.filetype == "typescriptreact" then
                vim.cmd("OrganizeImports")
            end
        end
    end,
})

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--     callback = function()
--         -- try_lint without arguments runs the linters defined in `linters_by_ft`
--         -- for the current filetype
--         require("lint").try_lint()
--     end,
-- })
