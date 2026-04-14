return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mason-org/mason.nvim",
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
          ensure_installed = { "codelldb", "python" },
          automatic_installation = true,
        },
      },
      "igorlfs/nvim-dap-view",
    },
    keys = {
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Breakpoint",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<F6>",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<F7>",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
    },
    config = function()
      local dap = require("dap")
      local mason = vim.fn.stdpath("data") .. "/mason/packages"

      require("mason-nvim-dap").setup()

      dap.adapters.codelldb = {
        id = "codelldb",
        type = "executable",
        command = mason .. "/codelldb/codelldb",
      }

      dap.adapters.python = {
        type = "executable",
        command = mason .. "/debugpy/venv/bin/python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = vim.fn.getcwd(),
          stopAtEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.python = {
        {
          name = "Launch file",
          type = "python",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          console = "integratedTerminal",
        },
      }
    end,
  },
}
