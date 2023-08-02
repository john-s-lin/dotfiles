return {
  -- Add OneDark
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "darker",
      transparent = "true",
      enabled = "true",
    },
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = "true",
      enabled = "false",
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
