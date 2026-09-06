return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile", "VeryLazy" },
        cmd = { "TSInstallConfigured", "TSInstall", "TSUpdate", "TSUninstall" },
        config = function()
            local TS = require("nvim-treesitter")

            local ensure = {
                "c",
                "cpp",
                "html",
                "java",
                "python",
                "lua",
                "vim",
                "vimdoc",
                "markdown",
                "markdown_inline",
                "javascript",
                "typescript",
                "tsx",
                "rust",
            }

            TS.setup({})

            -- Keep downloads and compilation out of editor startup.
            vim.api.nvim_create_user_command("TSInstallConfigured", function()
                TS.install(ensure)
            end, { desc = "Install the configured Treesitter parsers" })

            -- enable highlighting and indentation via FileType autocmd
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ev)
                    if vim.bo[ev.buf].buftype ~= "" then
                        return
                    end
                    local lang = vim.treesitter.language.get_lang(ev.match)
                    if lang and pcall(vim.treesitter.language.inspect, lang) then
                        vim.treesitter.start(ev.buf)
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        vim.schedule(function()
                            for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
                                vim.wo[win].foldmethod = "expr"
                                vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                            end
                        end)
                    end
                end,
            })
        end,
    },
}
