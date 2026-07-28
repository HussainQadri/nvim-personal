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

      local function current_cwd()
        return vim.fn.getcwd()
      end

      local function python_path()
        local has_venv_selector, venv_selector = pcall(require, "venv-selector")
        if has_venv_selector then
          local selected_python = venv_selector.python()
          if selected_python and vim.fn.executable(selected_python) == 1 then
            return selected_python
          end
        end

        local active_venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
        if active_venv then
          local active_python = active_venv .. "/bin/python"
          if vim.fn.executable(active_python) == 1 then
            return active_python
          end
        end

        local python = vim.fn.exepath("python3")
        return python ~= "" and python or "python3"
      end

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
        vim.cmd("split")
        jump(api.nvim_get_current_win())
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
          cwd = current_cwd,
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          args = function()
            return require("dap.utils").splitstr(vim.fn.input("Program args: "))
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          breakpointMode = "file",
          initCommands = { "settings set target.inline-breakpoint-strategy always" },
          sourceLanguages = { "rust" },
        },
      }
      dap.configurations.python = {
        {
          name = "Launch file",
          type = "python",
          request = "launch",
          program = "${file}",
          cwd = current_cwd,
          pythonPath = python_path,
          console = "integratedTerminal",
        },
      }
    end,
  },
}
