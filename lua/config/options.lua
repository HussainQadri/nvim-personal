vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.timeoutlen = 300
vim.opt.updatetime = 200

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
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.fillchars = {
    eob = " ",
    horiz = "─",
    horizdown = "┬",
    horizup = "┴",
    vert = "│",
    vertleft = "┤",
    vertright = "├",
    verthoriz = "┼",
}
vim.opt.laststatus = 3
vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.cmdheight = 0
vim.opt.winborder = "rounded"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "typescript",
        "typescriptreact",
    },
    callback = function(args)
        local editorconfig = vim.b[args.buf].editorconfig or {}

        if editorconfig.indent_style == nil then
            vim.bo[args.buf].expandtab = true
        end
        if editorconfig.indent_size == nil and editorconfig.indent_style ~= "tab" then
            vim.bo[args.buf].shiftwidth = 2
            vim.bo[args.buf].softtabstop = 2
        end
        if editorconfig.tab_width == nil and editorconfig.indent_size == nil then
            vim.bo[args.buf].tabstop = 2
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})
