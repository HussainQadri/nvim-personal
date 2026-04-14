return {
  {
    "igorlfs/nvim-dap-view",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    keys = {
      { "<leader>du", "<cmd>DapViewToggle<cr>", desc = "Dap View" },
      { "<leader>dr", "<cmd>DapViewOpen<cr>", desc = "Open Dap View" },
      {
        "<leader>de",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Eval",
        mode = { "n", "x" },
      },
    },
    opts = {
      auto_toggle = true,
      winbar = {
        sections = { "watches", "scopes", "breakpoints", "threads", "console" },
        show_keymap_hints = false,
      },
      windows = {
        size = 0.40,
        position = "right",
      },
    },
  },
}
