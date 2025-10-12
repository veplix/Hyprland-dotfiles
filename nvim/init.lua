require("config.lazy")
vim.opt.termguicolors = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.keymap.set({ 'n', 'v' }, 'y', '"+y', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'y', '"+Y', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'p', '"+p', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'P', '"+P', { noremap = true })
vim.opt.clipboard = ""
