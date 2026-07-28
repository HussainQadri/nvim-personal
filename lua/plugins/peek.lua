return {
    {
        "toppair/peek.nvim",
        ft = "markdown",
        build = "deno task --quiet build:fast",
        cmd = { "PeekOpen", "PeekClose" },

        keys = {
            { "<leader>mp", "<cmd>PeekOpen<cr>",  desc = "Markdown preview" },
            { "<leader>mP", "<cmd>PeekClose<cr>", desc = "Close Markdown preview" },
        },

        opts = {
            app = "browser",
            theme = "dark",
            update_on_change = true,
        },

        config = function(_, opts)
            local peek = require("peek")
            peek.setup(opts)

            vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
            vim.api.nvim_create_user_command("PeekClose", peek.close, {})
        end,
    },
}
