-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Go to Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- Remap Esc key to "jj" and "kk" in Insert mode
vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.keymap.set("i", "kk", "<ESC>", { silent = true })
