local M = {}
local config = require("FTerminal.config")

function M.setup(opts)
    opts = opts or {}
    for key, value in pairs(opts) do
        config[key] = value
    end
    require "FTerminal.core"
end

return M
