local null_ls = require("null-ls")

local opts = {
  sources = {
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.ruff,
  },
}

local plugins = {
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {
      "python",
    },
    opts = opts,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "mypy",
        "pyright",
        "ruff",
      },
    },
  },
}

return plugins
