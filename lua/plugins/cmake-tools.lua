return {
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "cmake", "cpp", "c" },
    dependencies = { "akinsho/toggleterm.nvim" },
    opts = {
      cmake_dap_configuration = {
        name = "CMake Debug",
        type = "cppdbg",
        request = "launch",
        stopAtEntry = false,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "Enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
      cmake_executor = {
        name = "toggleterm",
        opts = {
          direction = "horizontal",
          singleton = true,
          auto_scroll = true,
          close_on_exit = false,
        },
      },
      cmake_runner = {
        name = "toggleterm",
        opts = {
          direction = "horizontal",
          singleton = true,
          auto_scroll = true,
          close_on_exit = false,
        },
      },
    },
    keys = {
      { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "cmake generate" },
      { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "cmake build" },
      { "<leader>cp", "<cmd>CMakeRun<cr>", desc = "cmake run" },
      { "<leader>ct", "<cmd>CMakeSelectTarget<cr>", desc = "cmake select target" },
      { "<leader>cs", "<cmd>CMakeSelectBuildType<cr>", desc = "cmake select build type" },
      { "<leader>ce", "<cmd>CMakeCloseExecutor<cr>", desc = "cmake close executor" },
      {
        "<leader>cd",
        function()
          local cmake = require("cmake-tools")
          local path = cmake.get_launch_target_path()
          if type(path) == "table" and path.wait then
            path = path:wait()
          end
          if not path or path == "" then
            vim.notify("No launch target set. Use <leader>ct to select one.", vim.log.levels.WARN)
            return
          end
          pcall(vim.cmd, "CMakeCloseExecutor")
          pcall(vim.cmd, "CMakeCloseRunner")
          require("dap").run({
            name = "CMake Debug",
            type = "cppdbg",
            request = "launch",
            program = path,
            cwd = vim.fn.getcwd(),
            stopAtEntry = false,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "Enable pretty printing",
                ignoreFailures = false,
              },
            },
          })
        end,
        desc = "cmake debug (dap)",
      },
    },
  },
}
