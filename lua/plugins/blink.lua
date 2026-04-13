return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("blink.cmp").setup({
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          menu = {
            auto_show = false,
          },
          ghost_text = {
            enabled = false,
          },
        },
        keymap = {
          preset = "default",
          ["<CR>"] = { "fallback" },
          ["<C-y>"] = { "select_and_accept" },
          ["<Tab>"] = { "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "snippet_backward", "fallback" },
          ["<C-n>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_next()
              end
            end,
            "show",
          },
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-@>"] = { "show", "show_documentation", "hide_documentation" },
          ["<Nul>"] = { "show", "show_documentation", "hide_documentation" },
        },
      })
    end,
  },
}
