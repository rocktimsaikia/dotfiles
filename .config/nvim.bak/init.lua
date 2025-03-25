require("init-packer")
require("core.globals")
require("core.options")
require("core.autocmds")
require("core.keymaps")

require("plugins.nvim-treesitter")
require("plugins.nvim-tree")
require("plugins.lualine")
require("plugins.smooth-cursor")

require("plugins.lsp.nvim-lspconfig")
require("plugins.lsp.nvim-cmp")
