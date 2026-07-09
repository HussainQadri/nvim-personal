return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diff" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Diff" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
  },
  opts = {},
}
