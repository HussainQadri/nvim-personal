return {
  {
    "nvim-java/nvim-java",
    keys = {
      { "<leader>jr", "<cmd>JavaRunnerRunMain<cr>", desc = "run main" },
      {
        "<leader>js",
        function()
          pcall(vim.cmd, "JavaRunnerStopMain")
          pcall(vim.cmd, "JavaRunnerToggleLogs")
        end,
        desc = "stop main + close logs",
      },
      { "<leader>jl", "<cmd>JavaRunnerToggleLogs<cr>", desc = "toggle logs" },
    },
  },
}
