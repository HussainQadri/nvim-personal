return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets", "onsails/lspkind.nvim" },
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("blink.cmp").setup({
        appearance = {
          kind_icons = require("lspkind").symbol_map,
        },
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
            border = "rounded",
            draw = {
              columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 1 },
                { "kind" },
              },
            },
          },
          documentation = {
            window = { border = "rounded" },
          },
          ghost_text = {
            enabled = false,
          },
        },
        signature = {
          window = { border = "rounded" },
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
        cmdline = {
          completion = {
            menu = { auto_show = true },
          },
        },
      })
    end,
  },
}
