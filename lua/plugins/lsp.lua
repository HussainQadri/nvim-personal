return {
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        cmd = { "LspInstall", "LspUninstall" },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            -- Install servers explicitly with :Mason or :LspInstall.
            ensure_installed = {},
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
            local python_root_markers = {
                "pyproject.toml",
                "ruff.toml",
                ".ruff.toml",
                "pyrefly.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "manage.py",
                ".git",
            }

            vim.lsp.config("clangd", {
                cmd = { "clangd", "--fallback-style=GNU" },
                capabilities = capabilities,
            })

            vim.lsp.config("pyrefly", {
                cmd = { "pyrefly", "lsp" },
                filetypes = { "python" },
                root_markers = python_root_markers,
                workspace_required = true,
                capabilities = capabilities,
                on_exit = function(code)
                    if code ~= 0 then
                        vim.schedule(function()
                            vim.notify("Pyrefly exited with code: " .. code, vim.log.levels.ERROR)
                        end)
                    end
                end,
            })
            vim.lsp.config("vtsls", {
                capabilities = capabilities,
                settings = {
                    ["js/ts"] = {
                        implicitProjectConfig = {
                            checkJs = true,
                            strict = false,
                        },
                    },
                    typescript = {
                        format = {
                            indentSize = 2,
                            tabSize = 2,
                            convertTabsToSpaces = true,
                            semicolons = "insert",
                            insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
                        },
                    },
                    javascript = {
                        format = {
                            indentSize = 2,
                            tabSize = 2,
                            convertTabsToSpaces = true,
                            semicolons = "insert",
                            insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
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
                root_markers = python_root_markers,
                workspace_required = true,
                capabilities = capabilities,
                on_attach = function(client)
                    client.server_capabilities.hoverProvider = false
                end,
            })
            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
            })

            vim.lsp.enable({ "clangd", "lua_ls", "pyrefly", "ruff", "rust_analyzer", "vtsls" })

            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = false,
                virtual_lines = {
                    overflow = "wrap",
                },
                float = {
                    border = "rounded",
                    source = "if_many",
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
                    m("n", "grr", function() Snacks.picker.lsp_references() end, "References")
                    m("n", "gri", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
                    m("n", "grt", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
                    m("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                    m("n", "K", vim.lsp.buf.hover, "Hover")
                    m("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
                    m("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
                    m("n", "<leader>cm", "<cmd>Mason<cr>", "Mason")
                end,
            })
        end,
    },
}
