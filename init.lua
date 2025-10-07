--------------------------------------
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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = { transparent_background = true, }},
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},
    { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { 'nvim-lua/plenary.nvim' }}, 
    { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
    { "nvim-treesitter/nvim-treesitter-context", dependencies = { "nvim-treesitter/nvim-treesitter" }},
    { 'nvim-mini/mini.indentscope', version = '*' },
  },
  checker = { enabled = true },
  opts = {
    -- symbol = "▏",
    symbol = "│",
    options = { try_as_border = true },
  }
})

local builtin = require("telescope.builtin")

require('mini.indentscope').setup({
    options = {
        -- Type of scope's border: which line(s) with smaller indent to
        -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
        border = 'both',

        -- Whether to use cursor column when computing reference indent.
        -- Useful to see incremental scopes with horizontal cursor movements.
        indent_at_cursor = true,

        -- Maximum number of lines above or below within which scope is computed
        n_lines = 10000,

        -- Whether to first check input line to be a border of adjacent scope.
        -- Use it if you want to place cursor on function header to get scope of
        -- its body.
        try_as_border = false,
    },
    symbol = "│",
})
require("catppuccin").setup({ opts = { transparent_background = true },})
require("lualine").setup()
require("telescope")
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "cpp" },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
})
require("treesitter-context").setup({
    enable = true,
    max_lines = 5, 

    min_window_height = 5, 
    mode = 'topline',    
    separator = '─',
})

----------------------------------------
vim.cmd.colorscheme "catppuccin"
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

------------------------------------------
-- Move current line up/down with Alt-j/k
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('n', '<S-Return>', ":vsplit<Return>", opts)

-- New tab
vim.keymap.set("n", "te", ":tabedit")
vim.keymap.set("n", "<tab>", ":tabnext<Return>", opts)
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)


vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.opt.statuscolumn = "  %{v:lnum}     "
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
