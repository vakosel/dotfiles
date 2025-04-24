-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local o = vim.o
local g = vim.g
local opt = vim.opt
-- Indenting
o.expandtab = true -- convert tabs to spaces
-- o.shiftwidth = 4
o.shiftwidth = 2 -- the number of spaces inserted for each indentation
-- o.tabstop = 4
o.tabstop = 2 -- insert 2 spaces for a tab
o.softtabstop = 4
o.cursorlineopt = "number" -- to enable cursorline!
o.smartindent = true -- make indenting smarter again
-- o.fillchars = "eob:~"

-- set filetype for .CBL COBOL files.
-- vim.cmd([[ au BufRead,BufNewFile *.CBL set filetype=cobol ]])

o.backup = false -- creates a backup file
o.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
o.cmdheight = 1 -- more space in the neovim command line for displaying messages
--o.completeopt = { "menuone", "noselect" } -- mostly just for cmp

o.conceallevel = 0 -- so that `` is visible in markdown files
--o.fileencoding = "utf-8" -- the encoding written to a file
o.hlsearch = true -- highlight all matches on previous search pattern
o.ignorecase = true -- ignore case in search patterns
o.mouse = "a" -- allow the mouse to be used in neovim
o.pumheight = 10 -- pop up menu height
o.showmode = false -- we don't need to see things like -- INSERT -- anymore
o.showtabline = 0 -- always show tabs
o.smartcase = true -- smart case

o.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
o.splitbelow = true -- force all horizontal splits to go below current window
o.splitright = true -- force all vertical splits to go to the right of current window
o.swapfile = false -- creates a swapfile
o.termguicolors = true -- set term gui colors (most terminals support this)
o.timeout = true
o.timeoutlen = 400 -- time to wait for a mapped sequence to complete (in milliseconds)
o.undofile = true -- enable persistent undo

-- interval for writing swap file to disk, also used by gitsigns
--
o.updatetime = 250 -- faster completion (4000ms default)
o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
o.cursorline = true -- highlight the current line

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

-- Numbers
--
o.number = true -- set numbered lines
o.numberwidth = 4 -- minimal number of columns to use for the line number {default 4}
o.ruler = false -- hide the line and column number of the cursor position
o.relativenumber = true

-- disable nvim intro
vim.opt.shortmess:append("sI")

o.laststatus = 3 -- only the last window will always have a status line
o.showcmd = false -- hide (partial) command in the last line of the screen (for performance)
o.wrap = false -- display lines as one long line
o.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
o.sidescrolloff = 8 -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
--o.guifont = "CaskaydiaCove NF:h13" -- the font used in graphical neovim applications
o.linebreak = true
--o.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
--o.shellcmdflag =
--  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
o.shellquote = ""

-- disable some default providers
-- g.loaded_node_provider = 0
-- g.loaded_python3_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH
