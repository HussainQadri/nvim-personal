return {
  "oskarnurm/koda.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
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
    vim.cmd("colorscheme koda-dark")
  end,
}
