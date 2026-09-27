return {
  "nvim-mini/mini.pairs",
  version = "*",
  -- Set up before a picker prompt can claim <CR>/<BS> for its buffer.
  -- mini.pairs only creates its global mappings if maparg() is empty.
  lazy = false,
  config = function()
    require("mini.pairs").setup({
      mappings = {
        ['"'] = false,
        ["'"] = false,
        ["`"] = false,
      },
    })
  end,
}
