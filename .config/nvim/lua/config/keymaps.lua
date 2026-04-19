-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

---@diagnostic disable-next-line: undefined-global
local vim = vim

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<F8>", ":w <bar> exec 'term python '.shellescape('%')<CR>")

-- Terminal navigation keymaps for ToggleTerm
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- map("n", "<F9>", function()
--   -- directory of the current file
--   local cwd = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
--   local uv_project = false
--
--   -- Walk upward to detect uv project
--   local dir = cwd
--   while dir ~= "/" do
--     if vim.fn.filereadable(dir .. "/pyproject.toml") == 1 or vim.fn.filereadable(dir .. "/uv.lock") == 1 then
--       uv_project = true
--       break
--     end
--     dir = vim.fn.fnamemodify(dir, ":h")
--   end
--
--   -- absolute path to file
--   local file = vim.fn.shellescape(vim.fn.expand("%:p"))
--
--   if uv_project then
--     vim.cmd("!uv run python " .. file)
--   else
--     vim.cmd("!python " .. file)
--   end
-- end, { desc = "Smart run: uv if project, else system python" })
