return {
  {
    "oskarnurm/koda.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local soft = "#cfcfcf"
      local mid  = "#a8a8a8"
      require("koda").setup({
        transparent = true,
        colors = {
          emphasis = soft,
          func     = soft,
          string   = soft,
          char     = soft,
          special  = soft,
          border   = soft,
          keyword  = mid,
          type     = mid,
          operator = mid,
        },
      })
      vim.cmd.colorscheme("koda-dark")
    end,
  },
}
