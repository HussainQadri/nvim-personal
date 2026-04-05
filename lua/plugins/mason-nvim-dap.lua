return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "cpptools", "python" },
        automatic_installation = true,
        handlers = {
          python = function() end,
        },
      })
    end,
  },
}
