return {
  {
    "folke/which-key.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      preset = "helix",
      disable = {
        ft = { "snacks_terminal" },
        bt = { "terminal" },
      },
      icons = {
        rules = {
          { plugin = "lazy.nvim", icon = "󰒲", color = "azure" },
          { pattern = "lazy",     icon = "󰒲", color = "azure" },
        },
      },
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>r", group = "run" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "z", group = "fold" },
        },
      },
    },
  },
}
