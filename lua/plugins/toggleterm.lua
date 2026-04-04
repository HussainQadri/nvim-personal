return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>ft", desc = "Toggle Toggleterm" },
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
