-- Eventually when null-ls is fully deprecated, you may have to rename
-- require("null-ls") => require("none-ls")
-- Ref: https://github.com/LazyVim/LazyVim/blob/7cac6f064c5b30f6b0ae4dffab62100aa6fe2568/lua/lazyvim/config/init.lua#L83
local none_ls = require("null-ls")

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
