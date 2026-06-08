local M = {}

---orbit.nvim の初期化を行う。
---@param opts OrbitConfig|nil
function M.setup(opts)
  require("orbit.config").setup(opts)
  require("orbit.workspace.state").setup_tracking()
  require("orbit.commands").setup()
end

return M
