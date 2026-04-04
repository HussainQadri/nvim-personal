return {
  {
    "aktersnurra/no-clown-fiesta.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("no-clown-fiesta").setup({
        theme = "dark",
        transparent = false,
        styles = {
          comments = {},
          functions = {},
          keywords = {},
          lsp = {},
          match_paren = {},
          type = {},
          variables = {},
        },
      })

      vim.cmd.colorscheme("no-clown-fiesta")
    end,
  },
}
