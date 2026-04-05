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
      ensure_installed = { "clangd" },
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

      vim.lsp.config("ty", {
        cmd = { "ty", "server" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", ".git" },
        capabilities = capabilities,
      })

      vim.lsp.enable({ "clangd", "ty" })

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

          m("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, "Goto Definition")
          m("n", "gr", "<cmd>Telescope lsp_references<cr>", "References")
          m("n", "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, "Goto Implementation")
          m("n", "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, "Goto Type Definition")
          m("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          m("n", "K", vim.lsp.buf.hover, "Hover")
          m("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          m("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
          m({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          m("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          m("n", "<leader>cm", "<cmd>Mason<cr>", "Mason")
        end,
      })
    end,
  },
}
