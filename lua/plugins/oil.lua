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
    -- Load for directory buffers too, including `nvim .` and `:edit dir/`.
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("personal_oil_loader", { clear = true }),
      nested = true,
      callback = function(args)
        if package.loaded.oil then
          return true
        end
        local name = vim.api.nvim_buf_get_name(args.buf)
        if name ~= "" and vim.fn.isdirectory(name) == 1 then
          require("oil").open(name)
          return true
        end
      end,
    })
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
  cmd = "Oil",
}
