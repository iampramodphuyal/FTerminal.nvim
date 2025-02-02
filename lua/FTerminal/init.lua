local M = {}
local config = require("FTerminal.config")

function M.setup(opts)
    opts = opts or {}
    for key, value in pairs(opts) do
        config[key] = value
    end
    print("FTerminal Loaded")
    require "FTerminal.core"
    require "FTerminal.commands"
end

return M
