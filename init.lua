vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

------------------------------------------------------------------------------------------
--- Keybindings::
-- Move current line up/down with Alt-j/k
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('n', '<S-Return>', ":vsplit<Return>", opts)

-- Duplicate line down (Shift+Alt+j)
vim.keymap.set('n', '<M-J>', ':copy .<CR>', { noremap = true, silent = true })

-- Duplicate line up (Shift+Alt+k)
vim.keymap.set('n', '<M-K>', ':copy .-1<CR>', { noremap = true, silent = true })

-- Indent with Tab in Normal mode
vim.keymap.set('n', '<Tab>', '>>', { noremap = true, silent = true })

-- Indent with Tab in Visual mode (and maintain selection)
vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, silent = true })

-- Shift+Tab to unindent in Normal mode
vim.keymap.set('n', '<S-Tab>', '<<', { noremap = true, silent = true })

-- Shift+Tab to unindent in Visual mode (and maintain selection)
vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>vs", ":vsplit<Return>", opts)

vim.opt.statuscolumn = "  %{v:lnum}     "
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
--- Bootstrap lazy.nvim::
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
require("lazy").setup("plugins")
------------------------------------------------------------------------------------------
