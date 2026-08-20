return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = {
      "icon",
      "permissions",
      "size",
      "mtime",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "directory",
      callback = function(args)
        local name = vim.api.nvim_buf_get_name(args.buf)
        if name:match("^oil://") then
          vim.bo[args.buf].filetype = "oil"
        end
      end,
    })
  end,
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
  lazy = false,
}
