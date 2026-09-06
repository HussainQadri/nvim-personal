return {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status") -- to configure lazy pending updates count

        local function macro_recording()
            local register = vim.fn.reg_recording()
            if register == "" then
                return ""
            end

            return "recording @" .. register
        end

        vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
            callback = function()
                vim.schedule(function()
                    lualine.refresh({
                        place = { "statusline" },
                    })
                end)
            end,
        })

        lualine.setup({
            options = {
                theme = "auto",
            },
            sections = {
                lualine_b = {
                    { "branch", icon = "" },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = " ",
                        },
                    },
                },
                lualine_c = {
                    { "filename" },
                    { "filetype" },
                },
                lualine_x = {
                    {
                        macro_recording,
                        color = { fg = "#f6c177", gui = "bold" },
                    },
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                    },
                },
            },
        })
    end,
}
