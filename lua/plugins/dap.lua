return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "debug: continue/start",
      },
      {
        "<F7>",
        function()
          require("dap").step_over()
        end,
        desc = "debug: step over",
      },
      {
        "<F6>",
        function()
          require("dap").step_into()
        end,
        desc = "debug: step into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "debug: step out",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "debug: toggle breakpoint",
      },
      {
        "<leader>da",
        function()
          require("dap").run({
            type = "java",
            request = "attach",
            name = "Attach to Gradle JavaFX",
            hostName = "127.0.0.1",
            port = 5005,
          })
        end,
        desc = "debug: attach to gradle java",
      },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dR", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      local dap = require("dap")
      local cmake = require("cmake-tools")

      dap.configurations.cpp = {
        {
          name = "CMake Debug",
          type = "codelldb",
          request = "launch",
          program = function()
            return cmake.get_launch_target_path()
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
