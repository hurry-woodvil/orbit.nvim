local defaults = require("orbit.config.defaults")

local M = {}

function M.setup(opts)
end

function M.get()
  return vim.deepcopy(defaults)
end

function M.reset()
end

return M
