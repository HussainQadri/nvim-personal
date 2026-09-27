local soft_white = "#c8c8c8"

return {
    {
        "oskarnurm/koda.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("koda").setup({
                transparent = false,
                colors = {
                    dark = {
                        border = "#4a4a4a",
                        emphasis = "#d0d0d0",
                        func = soft_white,
                        string = soft_white,
                        char = soft_white,
                        special = soft_white,
                    },
                },
            })
            vim.cmd.colorscheme("koda-dark")
        end,
    },
}
