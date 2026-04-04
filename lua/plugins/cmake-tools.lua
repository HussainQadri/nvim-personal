return {
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "cmake", "cpp", "c" },
    dependencies = { "akinsho/toggleterm.nvim" },
    opts = {
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
    },
  },
}
