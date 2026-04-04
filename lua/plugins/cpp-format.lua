return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        h = { "clang-format" },
        hpp = { "clang-format" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = {
            '--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never, BreakBeforeBraces: Attach, AccessModifierOffset: -4, AllowShortFunctionsOnASingleLine: None, AllowShortBlocksOnASingleLine: Never, DerivePointerAlignment: false, PointerAlignment: Left, ReferenceAlignment: Left}',
          },
        },
      },
    },
  },
}
