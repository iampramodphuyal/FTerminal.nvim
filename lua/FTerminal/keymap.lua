local M = {}
local core = require "FTerminal.core"
-- Keybinding to toggle the floating terminal
vim.keymap.set({ "n", "t" }, "<leader>ft", core.toggle_floating_term, { noremap = true, silent = true })

return M
