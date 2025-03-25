-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/nightwarriorftw/.cache/nvim/packer_hererocks/2.1.1713484068/share/lua/5.1/?.lua;/home/nightwarriorftw/.cache/nvim/packer_hererocks/2.1.1713484068/share/lua/5.1/?/init.lua;/home/nightwarriorftw/.cache/nvim/packer_hererocks/2.1.1713484068/lib/luarocks/rocks-5.1/?.lua;/home/nightwarriorftw/.cache/nvim/packer_hererocks/2.1.1713484068/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/nightwarriorftw/.cache/nvim/packer_hererocks/2.1.1713484068/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    config = { "\27LJ\2\ny\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\npaths\1\0\1\npaths\0\1\2\0\0\16../snippets\14lazy_load luasnip.loaders.from_vscode\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["SmoothCursor.nvim"] = {
    config = { "\27LJ\2\n>\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\17smoothcursor\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/SmoothCursor.nvim",
    url = "https://github.com/gen740/SmoothCursor.nvim"
  },
  ["aerial.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vaerial\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/aerial.nvim",
    url = "https://github.com/stevearc/aerial.nvim"
  },
  ["arrow.nvim"] = {
    config = { "\27LJ\2\ng\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\22buffer_leader_key\6m\15leader_key\6;\15show_icons\1\nsetup\narrow\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/arrow.nvim",
    url = "https://github.com/otavioschwanck/arrow.nvim"
  },
  ["better-escape.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/opt/better-escape.vim",
    url = "https://github.com/jdhao/better-escape.vim"
  },
  ["bigfile.nvim"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/bigfile.nvim",
    url = "https://github.com/LunarVim/bigfile.nvim"
  },
  ["boole.nvim"] = {
    config = { "\27LJ\2\nx\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmappings\1\0\1\rmappings\0\1\0\2\14decrement\n<C-x>\14increment\n<C-a>\nsetup\nboole\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/boole.nvim",
    url = "https://github.com/nat-418/boole.nvim"
  },
  ["color-switch.nvim"] = {
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17color-switch\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/color-switch.nvim",
    url = "https://github.com/rocktimsaikia/color-switch.nvim"
  },
  ["conform.nvim"] = {
    config = { "\27LJ\2\n·\5\0\0\5\0&\0)6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0=\4\14\0035\4\15\0=\4\16\0035\4\17\0=\4\18\0035\4\19\0=\4\20\0035\4\21\0=\4\22\0035\4\23\0=\4\24\0035\4\25\0=\4\26\0035\4\27\0=\4\28\0035\4\29\0=\4\30\0035\4\31\0=\4 \0035\4!\0=\4\"\0035\4#\0=\4$\3=\3%\2B\0\2\1K\0\1\0\21formatters_by_ft\6c\1\2\0\0\17clang-format\ngleam\1\2\0\0\ngleam\trust\1\2\0\0\frustfmt\ago\1\3\0\0\ngofmt\fgolines\ash\1\2\0\0\16shellharden\bcss\1\2\0\0\14prettierd\njsonc\1\2\0\0\14prettierd\tjson\1\2\0\0\14prettierd\20typescriptreact\1\2\0\0\14prettierd\20javascriptreact\1\2\0\0\14prettierd\15typescript\1\2\0\0\14prettierd\15javascript\1\2\0\0\14prettierd\thtml\1\2\0\0\14prettierd\vpython\1\2\0\0\nblack\blua\1\0\16\trust\0\ash\0\ago\0\15htmldjango\0\20typescriptreact\0\blua\0\bcss\0\njsonc\0\tjson\0\20javascriptreact\0\15typescript\0\15javascript\0\6c\0\thtml\0\ngleam\0\vpython\0\1\2\0\0\vstylua\19format_on_save\1\0\2\19format_on_save\0\21formatters_by_ft\0\1\0\2\17lsp_fallback\2\15timeout_ms\3Ù\3\nsetup\fconform\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/conform.nvim",
    url = "https://github.com/stevearc/conform.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["git-blame.nvim"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/git-blame.nvim",
    url = "https://github.com/f-person/git-blame.nvim"
  },
  ["glance.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vglance\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/glance.nvim",
    url = "https://github.com/dnlhc/glance.nvim"
  },
  ["gruvbox-material"] = {
    config = { "\27LJ\2\n§\1\0\0\3\0\a\0\r6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\2\6\0B\0\2\1K\0\1\0005highlight ColorColumn ctermbg=None guibg=#232423\a80\16colorcolumn\bopt!colorscheme gruvbox-material\bcmd\bvim\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/gruvbox-material",
    url = "https://github.com/sainnhe/gruvbox-material"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\nU\0\0\5\0\5\0\b6\0\0\0009\0\1\0009\0\2\0)\2\0\0'\3\3\0005\4\4\0B\0\4\1K\0\1\0\1\0\1\afg\f#232a2d\16Lowcontrast\16nvim_set_hl\bapi\bvimì\2\1\0\6\0\16\0\0236\0\0\0'\2\1\0B\0\2\0029\1\2\0009\3\3\0009\3\4\0033\4\5\0B\1\3\0016\1\0\0'\3\6\0B\1\2\0029\1\a\0015\3\v\0005\4\b\0005\5\t\0=\5\n\4=\4\f\0035\4\r\0005\5\14\0=\5\n\4=\4\15\3B\1\2\1K\0\1\0\nscope\1\2\0\0\14@function\1\0\2\fenabled\2\14highlight\0\vindent\1\0\2\nscope\0\vindent\0\14highlight\1\2\0\0\16Lowcontrast\1\0\2\tchar\b‚ñè\14highlight\0\nsetup\bibl\0\20HIGHLIGHT_SETUP\ttype\rregister\14ibl.hooks\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["live-server.nvim"] = {
    commands = { "LiveServerStart", "LiveServerStop" },
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16live-server\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/opt/live-server.nvim",
    url = "https://github.com/barrett-ruth/live-server.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  ["no-neck-pain.nvim"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/no-neck-pain.nvim",
    url = "https://github.com/shortcuts/no-neck-pain.nvim"
  },
  ["numb.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/numb.nvim",
    url = "https://github.com/nacro90/numb.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-ts-context-commentstring"] = {
    config = { "\27LJ\2\nÖ\1\0\0\3\0\6\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\3\0009\0\4\0+\1\2\0=\1\5\0K\0\1\0)skip_ts_context_commentstring_module\6g\bvim\nsetup\29ts_context_commentstring\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["oil.nvim"] = {
    config = { "\27LJ\2\nk\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\17view_options\1\0\1\17view_options\0\1\0\1\16show_hidden\2\nsetup\boil\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/oil.nvim",
    url = "https://github.com/stevearc/oil.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/kkharji/sqlite.lua"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["telescope-smart-history.nvim"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/telescope-smart-history.nvim",
    url = "https://github.com/nvim-telescope/telescope-smart-history.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n·\3\0\0\5\0\14\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\3=\3\v\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\f\0'\2\r\0B\0\2\1K\0\1\0\18smart_history\19load_extension\rdefaults\1\0\1\rdefaults\0\fhistory\1\0\2\tpath<~/.local/share/nvim/databases/telescope_history.sqlite3\nlimit\3d\fpreview\1\0\1\15treesitter\1\25file_ignore_patterns\1\0\3\fhistory\0\25file_ignore_patterns\0\fpreview\0\1\15\0\0\rweb%-sdk\14storybook\16web%-static\tpolr\17node_modules\14web/tests\15web/public\t.git\18**/migrations\14api/tests\21api/static_media\nbuild\18.pytest_cache\f.github\nsetup\14telescope\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["text-case.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rtextcase\frequire\0" },
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/text-case.nvim",
    url = "https://github.com/johmsalas/text-case.nvim"
  },
  ["vim-capslock"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/vim-capslock",
    url = "https://github.com/tpope/vim-capslock"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-cursorword"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/vim-cursorword",
    url = "https://github.com/itchyny/vim-cursorword"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-obsession"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/vim-obsession",
    url = "https://github.com/tpope/vim-obsession"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-wayland-clipboard"] = {
    loaded = true,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/start/vim-wayland-clipboard",
    url = "https://github.com/jasonccox/vim-wayland-clipboard"
  },
  ["yeet.nvim"] = {
    commands = { "Yeet" },
    config = { "\27LJ\2\n6\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\tyeet\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/nightwarriorftw/.local/share/nvim/site/pack/packer/opt/yeet.nvim",
    url = "https://github.com/samharju/yeet.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: markdown-preview.nvim
time([[Setup for markdown-preview.nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\2\0\0\rmarkdown\19mkdp_filetypes\6g\bvim\0", "setup", "markdown-preview.nvim")
time([[Setup for markdown-preview.nvim]], false)
-- Config for: boole.nvim
time([[Config for boole.nvim]], true)
try_loadstring("\27LJ\2\nx\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmappings\1\0\1\rmappings\0\1\0\2\14decrement\n<C-x>\14increment\n<C-a>\nsetup\nboole\frequire\0", "config", "boole.nvim")
time([[Config for boole.nvim]], false)
-- Config for: nvim-ts-context-commentstring
time([[Config for nvim-ts-context-commentstring]], true)
try_loadstring("\27LJ\2\nÖ\1\0\0\3\0\6\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\3\0009\0\4\0+\1\2\0=\1\5\0K\0\1\0)skip_ts_context_commentstring_module\6g\bvim\nsetup\29ts_context_commentstring\frequire\0", "config", "nvim-ts-context-commentstring")
time([[Config for nvim-ts-context-commentstring]], false)
-- Config for: oil.nvim
time([[Config for oil.nvim]], true)
try_loadstring("\27LJ\2\nk\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\17view_options\1\0\1\17view_options\0\1\0\1\16show_hidden\2\nsetup\boil\frequire\0", "config", "oil.nvim")
time([[Config for oil.nvim]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\ny\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\npaths\1\0\1\npaths\0\1\2\0\0\16../snippets\14lazy_load luasnip.loaders.from_vscode\frequire\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: SmoothCursor.nvim
time([[Config for SmoothCursor.nvim]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\17smoothcursor\frequire\0", "config", "SmoothCursor.nvim")
time([[Config for SmoothCursor.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n·\3\0\0\5\0\14\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\3=\3\v\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\f\0'\2\r\0B\0\2\1K\0\1\0\18smart_history\19load_extension\rdefaults\1\0\1\rdefaults\0\fhistory\1\0\2\tpath<~/.local/share/nvim/databases/telescope_history.sqlite3\nlimit\3d\fpreview\1\0\1\15treesitter\1\25file_ignore_patterns\1\0\3\fhistory\0\25file_ignore_patterns\0\fpreview\0\1\15\0\0\rweb%-sdk\14storybook\16web%-static\tpolr\17node_modules\14web/tests\15web/public\t.git\18**/migrations\14api/tests\21api/static_media\nbuild\18.pytest_cache\f.github\nsetup\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: aerial.nvim
time([[Config for aerial.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vaerial\frequire\0", "config", "aerial.nvim")
time([[Config for aerial.nvim]], false)
-- Config for: text-case.nvim
time([[Config for text-case.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rtextcase\frequire\0", "config", "text-case.nvim")
time([[Config for text-case.nvim]], false)
-- Config for: arrow.nvim
time([[Config for arrow.nvim]], true)
try_loadstring("\27LJ\2\ng\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\22buffer_leader_key\6m\15leader_key\6;\15show_icons\1\nsetup\narrow\frequire\0", "config", "arrow.nvim")
time([[Config for arrow.nvim]], false)
-- Config for: conform.nvim
time([[Config for conform.nvim]], true)
try_loadstring("\27LJ\2\n·\5\0\0\5\0&\0)6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0=\4\14\0035\4\15\0=\4\16\0035\4\17\0=\4\18\0035\4\19\0=\4\20\0035\4\21\0=\4\22\0035\4\23\0=\4\24\0035\4\25\0=\4\26\0035\4\27\0=\4\28\0035\4\29\0=\4\30\0035\4\31\0=\4 \0035\4!\0=\4\"\0035\4#\0=\4$\3=\3%\2B\0\2\1K\0\1\0\21formatters_by_ft\6c\1\2\0\0\17clang-format\ngleam\1\2\0\0\ngleam\trust\1\2\0\0\frustfmt\ago\1\3\0\0\ngofmt\fgolines\ash\1\2\0\0\16shellharden\bcss\1\2\0\0\14prettierd\njsonc\1\2\0\0\14prettierd\tjson\1\2\0\0\14prettierd\20typescriptreact\1\2\0\0\14prettierd\20javascriptreact\1\2\0\0\14prettierd\15typescript\1\2\0\0\14prettierd\15javascript\1\2\0\0\14prettierd\thtml\1\2\0\0\14prettierd\vpython\1\2\0\0\nblack\blua\1\0\16\trust\0\ash\0\ago\0\15htmldjango\0\20typescriptreact\0\blua\0\bcss\0\njsonc\0\tjson\0\20javascriptreact\0\15typescript\0\15javascript\0\6c\0\thtml\0\ngleam\0\vpython\0\1\2\0\0\vstylua\19format_on_save\1\0\2\19format_on_save\0\21formatters_by_ft\0\1\0\2\17lsp_fallback\2\15timeout_ms\3Ù\3\nsetup\fconform\frequire\0", "config", "conform.nvim")
time([[Config for conform.nvim]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\nU\0\0\5\0\5\0\b6\0\0\0009\0\1\0009\0\2\0)\2\0\0'\3\3\0005\4\4\0B\0\4\1K\0\1\0\1\0\1\afg\f#232a2d\16Lowcontrast\16nvim_set_hl\bapi\bvimì\2\1\0\6\0\16\0\0236\0\0\0'\2\1\0B\0\2\0029\1\2\0009\3\3\0009\3\4\0033\4\5\0B\1\3\0016\1\0\0'\3\6\0B\1\2\0029\1\a\0015\3\v\0005\4\b\0005\5\t\0=\5\n\4=\4\f\0035\4\r\0005\5\14\0=\5\n\4=\4\15\3B\1\2\1K\0\1\0\nscope\1\2\0\0\14@function\1\0\2\fenabled\2\14highlight\0\vindent\1\0\2\nscope\0\vindent\0\14highlight\1\2\0\0\16Lowcontrast\1\0\2\tchar\b‚ñè\14highlight\0\nsetup\bibl\0\20HIGHLIGHT_SETUP\ttype\rregister\14ibl.hooks\frequire\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: color-switch.nvim
time([[Config for color-switch.nvim]], true)
try_loadstring("\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17color-switch\frequire\0", "config", "color-switch.nvim")
time([[Config for color-switch.nvim]], false)
-- Config for: numb.nvim
time([[Config for numb.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0", "config", "numb.nvim")
time([[Config for numb.nvim]], false)
-- Config for: glance.nvim
time([[Config for glance.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vglance\frequire\0", "config", "glance.nvim")
time([[Config for glance.nvim]], false)
-- Config for: gruvbox-material
time([[Config for gruvbox-material]], true)
try_loadstring("\27LJ\2\n§\1\0\0\3\0\a\0\r6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\2\6\0B\0\2\1K\0\1\0005highlight ColorColumn ctermbg=None guibg=#232423\a80\16colorcolumn\bopt!colorscheme gruvbox-material\bcmd\bvim\0", "config", "gruvbox-material")
time([[Config for gruvbox-material]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.api.nvim_create_user_command, 'LiveServerStop', function(cmdargs)
          require('packer.load')({'live-server.nvim'}, { cmd = 'LiveServerStop', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'live-server.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('LiveServerStop ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Yeet', function(cmdargs)
          require('packer.load')({'yeet.nvim'}, { cmd = 'Yeet', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'yeet.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Yeet ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'LiveServerStart', function(cmdargs)
          require('packer.load')({'live-server.nvim'}, { cmd = 'LiveServerStart', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'live-server.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('LiveServerStart ', 'cmdline')
      end})
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'better-escape.vim', 'nvim-autopairs'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
