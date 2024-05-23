local M = {
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "pyright",
      "ruff",
      "ruff-lsp",
      "rust-analyzer",
    },
  },
}

function M.setup()
  require("mason").setup()

  require("mason-lspconfig").setup({
    ensure_installed = M.opts.ensure_installed,
  })

  local lspconfig = require("lspconfig")

  lspconfig.pyright.setup({
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
    },
    python = {
      analysis = {
        ignore = { "*" },
      },
    },
  })

  lspconfig.ruff.setup({})

  lspconfig.rust_analyzer.setup({})
end

return M
