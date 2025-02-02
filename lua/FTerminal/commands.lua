local M = {}
local core = require "FTerminal.core"

vim.api.nvim_create_user_command("ToogleFTerm", function()
    core.toggle_floating_term()
end, {})

return M
