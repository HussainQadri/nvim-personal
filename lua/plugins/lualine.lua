return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                globalstatus = true,
                component_separators = "",
                section_separators = "",
                disabled_filetypes = {
                    statusline = { "snacks_dashboard" },
                },
            },
            sections = {
                lualine_b = {
                    { "branch", icon = "" },
                    "diff",
                    "diagnostics",
                },
                lualine_c = { "filename", "filetype" },
                lualine_x = { "fileformat" },
                lualine_z = {},
            },
        })
    end,
}
