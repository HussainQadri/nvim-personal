return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "snacks_dashboard" },
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            separator = { left = "", right = "" },
            padding = { left = 1, right = 1 },
            color = { gui = "" },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "",
            separator = { left = "", right = "" },
            color = { gui = "" },
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = "E:",
              warn = "W:",
              info = "I:",
              hint = "H:",
            },
          },
          {
            function()
              local path = vim.fn.expand("%:p")
              return path ~= "" and vim.fn.fnamemodify(path, ":~") or ""
            end,
          },
        },
        lualine_x = {},
        lualine_y = {
          {
            "location",
            padding = { left = 0, right = 1 },
            separator = { left = "", right = "" },
            color = { gui = "" },
          },
        },
        lualine_z = {},
      },
    },
  },
}
