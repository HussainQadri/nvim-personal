return {
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = { "clangd", "pyrefly", "vtsls" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            vim.lsp.config("clangd", {
                cmd = { "clangd", "--fallback-style=GNU" },
                capabilities = capabilities,
            })

            vim.lsp.config("pyrefly", {
                cmd = { "pyrefly", "lsp" },
                filetypes = { "python" },
                root_markers = { "pyrefly.toml", "pyproject.toml", "setup.py", ".git" },
                capabilities = capabilities,
            })
            vim.lsp.config("vtsls", {
                capabilities = capabilities,
                settings = {
                    typescript = {
                        format = {
                            indentSize = 2,
                            tabSize = 2,
                            convertTabsToSpaces = true,
                            semicolons = "remove",
                        },
                    },
                    javascript = {
                        format = {
                            indentSize = 2,
                            tabSize = 2,
                            convertTabsToSpaces = true,
                            semicolons = "remove",
                        },
                    },
                },
            })
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        format = {
                            enable = true,
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "2",
                                tab_width = "2",
                            },
                        },
                    },
                },
            })
            vim.lsp.config("ruff", {
                capabilities = capabilities,
                on_attach = function(client)
                    client.server_capabilities.hoverProvider = false
                end,
            })

            vim.lsp.enable({ "clangd", "pyrefly", "ruff" })

            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client then
                        client.server_capabilities.semanticTokensProvider = nil
                    end

                    local buf = args.buf
                    local function m(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
                    end

                    m("n", "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
                    m("n", "gr", function() Snacks.picker.lsp_references() end, "References")
                    m("n", "gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
                    m("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
                    m("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                    m("n", "K", vim.lsp.buf.hover, "Hover")
                    m("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
                    m("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
                    m({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    m("n", "<leader>cm", "<cmd>Mason<cr>", "Mason")
                end,
            })
        end,
    },
}
