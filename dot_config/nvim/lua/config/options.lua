-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Performance optimization
vim.opt.updatetime = 300 -- faster CursorHold events (default: 4000ms)
vim.opt.timeoutlen = 300 -- faster key sequence timeout (default: 1000ms)

-- Add CJK (Chinese, Japanese, Korean) to spell check to prevent false positives
local opt = vim.opt
opt.spelllang = { "en", "cjk" }
