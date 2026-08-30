return {
    {
        "webhooked/kanso.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanso").setup({
                italics = false,
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                minimal = true,
                overrides = function(colors)
                    return {
                        ["@markup.italic"] = { italic = false },
                        FloatBorder = { fg = colors.palette.gray5 },
                        WinSeparator = { fg = colors.palette.gray5 },
                    }
                end,
                background = {
                    dark = "zen",
                    light = "pearl",
                },
            })
            vim.cmd.colorscheme("kanso-zen")
        end,
    },
}
