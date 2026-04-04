return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    config = function()
      local TS = require("nvim-treesitter")

      local ensure = {
        "c",
        "cpp",
        "java",
        "python",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
      }

      TS.setup({
        ensure_installed = ensure,
      })

      -- install missing parsers
      local installed = TS.get_installed and TS.get_installed() or {}
      local installed_set = {}
      for _, lang in ipairs(installed) do
        installed_set[lang] = true
      end
      local to_install = vim.tbl_filter(function(lang)
        return not installed_set[lang]
      end, ensure)
      if #to_install > 0 then
        TS.install(to_install)
      end

      -- enable highlighting and indentation via FileType autocmd
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if lang and pcall(vim.treesitter.language.inspect, lang) then
            vim.treesitter.start(ev.buf)
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
