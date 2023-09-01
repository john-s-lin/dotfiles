return {
  -- Add OneDark
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "darker",
      transparent = "true",
    },
    lazy = "true",
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = "true",
    },
    lazy = "true",
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
