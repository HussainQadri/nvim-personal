return {
  "nvim-java/nvim-java",
  ft = "java",
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local ok, blink = pcall(require, "blink.cmp")
    if ok then
      capabilities = blink.get_lsp_capabilities(capabilities)
    end

    vim.lsp.config("jdtls", {
      capabilities = capabilities,
    })

    require("java").setup({
      spring_boot_tools = { enable = false },
    })

    vim.lsp.enable("jdtls")
  end,
}
