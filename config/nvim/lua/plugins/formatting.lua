local M = {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
    },
  },
}

return M
