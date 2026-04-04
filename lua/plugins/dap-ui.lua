return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "nvim-neo-tree/neo-tree.nvim",
  },
  keys = {
    { "<leader>du", function() require("dapui").toggle() end, desc = "debug: toggle ui" },
    { "<leader>dr", function() require("dapui").open({ reset = true }) end, desc = "debug: reset ui layout" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "debug: hover variable" },
    { "<leader>dp", function() require("dap.ui.widgets").preview() end, desc = "debug: preview expression" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "x" } },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local events = require("neo-tree.events")

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "String" })

    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.6 },
            { id = "watches", size = 0.2 },
            { id = "breakpoints", size = 0.2 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 12,
          position = "bottom",
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    local function reset_dapui_if_debugging()
      if dap.session() then
        dapui.open({ reset = true })
      end
    end

    events.subscribe({
      event = events.NEO_TREE_WINDOW_AFTER_OPEN,
      handler = reset_dapui_if_debugging,
    })

    events.subscribe({
      event = events.NEO_TREE_WINDOW_AFTER_CLOSE,
      handler = reset_dapui_if_debugging,
    })
  end,
}
