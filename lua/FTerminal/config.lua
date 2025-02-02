local width = math.floor(vim.o.columns * 1)
local height = math.floor(vim.o.lines * 0.95)
local row = math.floor((vim.o.lines - height) / 2)
local col = math.floor((vim.o.columns - width) / 2)

M = {
    width = width,
    height = height,
    row = row,
    col = col
}

return M
