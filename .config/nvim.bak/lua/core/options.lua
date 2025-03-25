vim.opt.ttimeoutlen = -1

vim.opt.tabstop = 2 -- Set the number of spaces that a <Tab> in the file counts for.
vim.opt.shiftwidth = 2 -- Set the number of spaces to use for each step of (auto)indent.
vim.opt.expandtab = false -- Use tabs, not spaces.
vim.opt.smarttab = true -- Insert tabs on the start of a line according to shiftwidth.

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 8
vim.opt.termguicolors = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false

-- Cursor line
vim.opt.cursorline = true

--  Makes life easier
vim.opt.iskeyword:append("-")

-- Open vsplit to right
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.hidden = true

vim.g.git_messenger_floating_win_opts = { border = "rounded" }
vim.g.git_messenger_popup_content_margins = false

vim.g.copilot_filetypes = { markdown = true, yml = true }

-- Fix spell error by <C-x-s>
vim.opt.spell = true
vim.opt.spelllang = "en"

vim.g.doge_doc_standard_python = "numpy"
vim.g.doge_enable_mappings = 0
vim.g.doge_buffer_mappings = 0

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = [[^\./,\.\./$]]
-- Press `v` to open file in vertical split
vim.g.netrw_preview = 1 -- Enable preview window
vim.g.netrw_altv = 1 -- Open splits to the right
vim.g.netrw_winsize = 90 -- Set initial size of netrw window
vim.g.netrw_localrmdir = "rm -rf"
