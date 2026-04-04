vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.equalalways = false
vim.opt.signcolumn = "yes"
vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.fillchars = { eob = " " }
vim.opt.ruler = false
vim.opt.showmode = false

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})
