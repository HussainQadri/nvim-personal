return {
    {
        "webhooked/kanso.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanso").setup({
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                minimal = true,
                background = {
                    dark = "zen",
                    light = "pearl",
                },
            })
            vim.cmd.colorscheme("kanso-zen")
        end,
    },
}
