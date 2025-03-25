local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--- GENERAL MAPPINGS ---
vim.g.mapleader = " "

-- Quick bulk rename
map("n", "<leader>n", "*:%s//")

-- Select remaps
map("n", "vv", "V")
map("n", "V", "v$")

-- Clipboard
map("v", "<leader>y", '"+y')
map("n", "<leader>wy", 'viw"+y')

-- Disable arrow keys
map("", "<up>", "<nop>")
map("", "<down>", "<nop>")
map("", "<left>", "<nop>")
map("", "<right>", "<nop>")

-- Map Esc to jj
map("i", "jj", "<Esc>")

-- Clear search highlighting with <leader> and c
map("n", "<leader>c", ":nohl<CR>")

-- Split remapping
map("n", ",s", ":vsplit<CR>")
map("n", ",d", ":split<CR>")

-- Move around splits using Ctrl + {h,j,k,l}
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Reload configuration without restart nvim
map("n", "<leader>r", ":so %<CR>")

-- Fast saving with <leader> and s
map("n", "<leader>s", ":w<CR>")
map("n", "<leader>qa", ":qa<CR>")

-- -- Quickfix list
-- vim.cmd([[
-- function! ToggleQuickFix()
--     if empty(filter(getwininfo(), 'v:val.quickfix'))
--         copen
--     else
--         cclose
--     endif
-- endfunction
-- ]])
-- map("n", "wq", ":call ToggleQuickFix()<CR>")

-- Undo breakpoints
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ":", ":<C-g>u")
map("i", ";", ";<C-g>u")

--- PLUGIN KEY MAPPINGS ---

-- nvim-tree
map("n", "<C-,>", ":NvimTreeFindFileToggle<CR>")
map("n", "<C-c>", ":NvimTreeCollapse<CR>")

-- gitsigns

-- telescope
map("n", "<leader>h", ":Telescope help_tags<CR>")
map("n", "<leader>ff", ':lua require("telescope.builtin").find_files({ hidden=true })<CR>')
map("n", "<leader>fg", ':lua require("telescope.builtin").live_grep()<CR>')
map("n", "<leader>fb", ':lua require("telescope.builtin").buffers()<CR>')
map("n", "<leader>rr", ":Telescope lsp_references<CR>")
map("n", "<leader>gd", ":Telescope lsp_definations<CR>")
map("n", "<leader>tt", ":Telescope lsp_type_definitions<CR>")
-- telescope extensions
map("n", "<leader>fo", ':lua require("telescope.builtin").oldfiles()<CR>')
map("n", "<leader>gs", ':lua require("telescope.builtin").git_status()<CR>')
map("n", "<leader>fh", ':lua require("telescope.builtin").search_history()<CR>')

-- neogeon | create functio annotations
map("n", "<leader>nf", ":lua require('neogen').generate()<CR>")

map("n", "<M-s>", ":TSJToggle<CR>")

-- Plannery mapping for running tests
map("n", "<leader>t", "<Plug>PlenaryTestFile")

-- Git commit browser
map("n", "<leader>gb", ":GV<CR>")
map("n", "<leader>gc", ":GV!<CR>")

-- grapple.nvim
map("n", "<leader>aa", ":GrapplePopup tags<CR>")
map("n", "<leader>.", ":GrappleTag<CR>")

-- Git diff browser
local diffview_open = false

function toggle_diffview()
    if not diffview_open then
        vim.cmd("DiffviewOpen")
        diffview_open = true
    else
        vim.cmd("DiffviewClose")
        diffview_open = false
    end
end

-- Lua
vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>")
vim.keymap.set("n", "gR", "<CMD>Glance references<CR>")
vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>")
vim.keymap.set("n", "gM", "<CMD>Glance implementations<CR>")

-- map to go to the previous buffer in a split
map("n", "<leader>p", ":vsplit<CR>:b#<CR>")
-- map to go to definition in a split
map("n", "<leader>gd", ":vsplit<CR>:lua vim.lsp.buf.definition()<CR>")

-- text-case.nvim keymaps
-- nnoremap gal :lua require('textcase').current_word('to_lower_case')<CR>
-- nnoremap gas :lua require('textcase').current_word('to_snake_case')<CR>
-- nnoremap gad :lua require('textcase').current_word('to_dash_case')<CR>
-- nnoremap gan :lua require('textcase').current_word('to_constant_case')<CR>
-- nnoremap gad :lua require('textcase').current_word('to_dot_case')<CR>
-- nnoremap gaa :lua require('textcase').current_word('to_phrase_case')<CR>
-- nnoremap gac :lua require('textcase').current_word('to_camel_case')<CR>
-- nnoremap gap :lua require('textcase').current_word('to_pascal_case')<CR>
-- nnoremap gat :lua require('textcase').current_word('to_title_case')<CR>
-- nnoremap gaf :lua require('textcase').current_word('to_path_case')<CR>

-- nnoremap gaU :lua require('textcase').lsp_rename('to_upper_case')<CR>
-- nnoremap gaL :lua require('textcase').lsp_rename('to_lower_case')<CR>
-- nnoremap gaS :lua require('textcase').lsp_rename('to_snake_case')<CR>
-- nnoremap gaD :lua require('textcase').lsp_rename('to_dash_case')<CR>
-- nnoremap gaN :lua require('textcase').lsp_rename('to_constant_case')<CR>
-- nnoremap gaD :lua require('textcase').lsp_rename('to_dot_case')<CR>
-- nnoremap gaA :lua require('textcase').lsp_rename('to_phrase_case')<CR>
-- nnoremap gaC :lua require('textcase').lsp_rename('to_camel_case')<CR>
-- nnoremap gaP :lua require('textcase').lsp_rename('to_pascal_case')<CR>
-- nnoremap gaT :lua require('textcase').lsp_rename('to_title_case')<CR>
-- nnoremap gaF :lua require('textcase').lsp_rename('to_path_case')<CR>

-- nnoremap geu :lua require('textcase').operator('to_upper_case')<CR>
-- nnoremap gel :lua require('textcase').operator('to_lower_case')<CR>
-- nnoremap ges :lua require('textcase').operator('to_snake_case')<CR>
-- nnoremap ged :lua require('textcase').operator('to_dash_case')<CR>
-- nnoremap gen :lua require('textcase').operator('to_constant_case')<CR>
-- nnoremap ged :lua require('textcase').operator('to_dot_case')<CR>
-- nnoremap gea :lua require('textcase').operator('to_phrase_case')<CR>
-- nnoremap gec :lua require('textcase').operator('to_camel_case')<CR>
-- nnoremap gep :lua require('textcase').operator('to_pascal_case')<CR>
-- nnoremap get :lua require('textcase').operator('to_title_case')<CR>
-- nnoremap gef :lua require('textcase').operator('to_path_case')<CR>

vim.keymap.set("n", "<Leader>do", "<Plug>(doge-generate)")

-- Copy current buffer file name to clipboard
vim.keymap.set("n", "<Leader>,", ":let @+=expand('%:t')<CR>")

vim.keymap.set("n", "<Leader>cs", "<CMD>ColorSwitch<CR>")

-- vim.keymap.set("n", "-", "<CMD>Ex<CR>")
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>")
