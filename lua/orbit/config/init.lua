local defaults = require("orbit.config.defaults")

local M = {}

---@type OrbitConfig
local current = vim.deepcopy(defaults)

---@param opts OrbitConfig|nil
function M.setup(opts)
  current = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

---@return OrbitConfig
function M.get()
  return vim.deepcopy(current)
end

function M.reset()
  current = vim.deepcopy(defaults)
end

return M
