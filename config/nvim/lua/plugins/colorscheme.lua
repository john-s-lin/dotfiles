return {
  -- Add OneDark
  {
    "navarasu/onedark.nvim",
    event = "VeryLazy",
    opts = {
      style = "darker",
      transparent = "true",
      enabled = "false",
    },
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = "true",
      enabled = "true",
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
