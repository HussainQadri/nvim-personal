return {
  "nvim-mini/mini.pairs",
  version = "*",
  event = "InsertEnter",
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
