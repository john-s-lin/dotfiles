local M = {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "black",
      "pyright",
      "ruff",
      "ruff-lsp",
      "rust-analyzer",
    },
  },
}

return M
