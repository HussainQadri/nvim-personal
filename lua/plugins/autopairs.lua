return {
  "nvim-mini/mini.pairs",
  version = "*",
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
