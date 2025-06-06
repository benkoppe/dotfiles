-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Remove formatoptions for newlines after comments
-- Without this, the comment prefix is added after a new line in insert mode
vim.api.nvim_create_autocmd("FileType", {
  command = "set formatoptions-=ro",
})
