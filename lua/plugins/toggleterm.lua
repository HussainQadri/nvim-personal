return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-/>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = { "n", "t" } },
      { "<C-_>", "<cmd>ToggleTerm<cr>", desc = "which_key_ignore", mode = { "n", "t" } },
      { "<leader>ft", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    },
    opts = {
      direction = "horizontal",
      size = 11,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      shell = "powershell",
      close_on_exit = false,
      open_mapping = nil,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })
    end,
  },
}
