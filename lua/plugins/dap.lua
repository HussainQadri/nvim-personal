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

      dap.defaults.fallback.switchbuf = function(bufnr, line, column)
        local api = vim.api
        local function jump(win)
          api.nvim_win_set_buf(win, bufnr)
          pcall(api.nvim_win_set_cursor, win, { line, math.max(0, column - 1) })
          api.nvim_set_current_win(win)
        end
        for _, w in ipairs(api.nvim_tabpage_list_wins(0)) do
          if api.nvim_win_get_buf(w) == bufnr then
            return jump(w)
          end
        end
        for _, w in ipairs(api.nvim_tabpage_list_wins(0)) do
          local cfg = api.nvim_win_get_config(w)
          local b = api.nvim_win_get_buf(w)
          if cfg.relative == "" and not vim.wo[w].winfixbuf and vim.bo[b].buftype == "" then
            return jump(w)
          end
        end
        vim.cmd("split " .. api.nvim_buf_get_name(bufnr))
        pcall(api.nvim_win_set_cursor, 0, { line, math.max(0, column - 1) })
      end

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
