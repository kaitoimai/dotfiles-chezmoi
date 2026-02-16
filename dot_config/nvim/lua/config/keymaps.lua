-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Insert mode keymaps
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- Custom keymaps
vim.keymap.set("i", "<C-u>", function()
  return vim.fn.system('printf "%s" "$(uuidgen)"')
end, { expr = true, desc = "Insert UUID" })

-- emacs keybindings
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move down" })
vim.keymap.set("i", "<C-n>", "<Down>", { desc = "Move down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move up" })
vim.keymap.set("i", "<C-p>", "<Up>", { desc = "Move up" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right" })
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Move forward (right)" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left" })
vim.keymap.set("i", "<C-b>", "<Left>", { desc = "Move backward (left)" })
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Move to beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "Move to end of line" })
vim.keymap.set("i", "<C-d>", "<Del>", { desc = "Delete character forward" })

-- Normal mode keymaps
-- Move window
vim.keymap.set("n", "sh", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "sj", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "sk", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "sl", "<C-w>l", { desc = "Move to right window" })
