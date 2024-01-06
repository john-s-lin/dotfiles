local M = {
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

return M
