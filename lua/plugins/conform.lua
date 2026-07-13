return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        cmd = "ConformInfo",
        opts = {
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
                h = { "clang-format" },
                hpp = { "clang-format" },

                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
            },
            formatters = {
                ["clang-format"] = {
                    prepend_args = function(_, ctx)
                        local config = vim.fs.find({ ".clang-format", "_clang-format" }, {
                            upward = true,
                            path = ctx.dirname,
                        })[1]

                        if config then
                            return {}
                        end

                        return {
                            "--style={BasedOnStyle: LLVM, IndentWidth: 4, AccessModifierOffset: -4, AllowShortFunctionsOnASingleLine: None, PointerAlignment: Left, ReferenceAlignment: Left}",
                        }
                    end,
                },
            },
        },
    },
}
