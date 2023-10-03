local none_ls = require("none-ls")

local opts = {
  sources = {
    none_ls.builtins.diagnostics.mypy,
    none_ls.builtins.diagnostics.ruff,
  },
}

local plugins = {
  {
    "nvimtools/none-ls.nvim",
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
