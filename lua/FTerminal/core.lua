local M = {}
local float_term_win = nil -- Stores the floating terminal window ID
local float_term_buf = nil -- Stores the terminal buffer ID
local float_term_jobid = nil

local config = require("FTerminal.config")


function M.floatingTerminalWindow(bufId)
    -- Open floating window
    float_term_win = vim.api.nvim_open_win(bufId, true, {
        relative = "editor",
        row = config.row,
        col = config.col,
        width = config.width,
        height = config.height,
        style = "minimal",
        border = "rounded",
    })
    return float_term_win
end

function M.toggle_floating_term()
    if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
        -- Hide terminal by closing the window, but keep the buffer
        vim.api.nvim_win_close(float_term_win, true)
        float_term_win = nil
    else
        -- Reuse the existing buffer or create a new one
        if not float_term_buf or not vim.api.nvim_buf_is_valid(float_term_buf) then
            float_term_buf = vim.api.nvim_create_buf(false, true) -- No listed, no file
        end

        float_term_win = M.floatingTerminalWindow(float_term_buf)
        if not float_term_jobid then
            float_term_jobid = vim.fn.termopen(vim.o.shell)
        end
        vim.api.nvim_command("startinsert")
    end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if float_term_buf and vim.api.nvim_buf_is_valid(float_term_buf) then
            vim.api.nvim_buf_delete(float_term_buf, { force = true })
        end
    end,
})

function M.sendCommandToTerminal(cmd)
    cmd = cmd or {}
    if not float_term_jobid or vim.fn.jobwait({ float_term_jobid }, 0)[1] ~= -1 then
        float_term_win = nil -- Stores the floating terminal window ID
        float_term_buf = nil
        float_term_jobid = nil
        M.toggle_floating_term() --this will reset the float_term_jobid
        vim.api.nvim_set_current_win(float_term_win)
        vim.api.nvim_chan_send(float_term_jobid, cmd .. "\n")
    else
        M.floatingTerminalWindow(float_term_buf)
        vim.api.nvim_chan_send(float_term_jobid, cmd .. "\n")
    end
end

-- Keybinding to toggle the floating terminal
vim.keymap.set({ "n", "t" }, "<leader>ft", M.toggle_floating_term, { noremap = true, silent = true })

return M
