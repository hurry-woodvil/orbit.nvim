local M = {}

-- orbit.nvim の user command 定義を集約する。
-- 個別 command は対応する Task Issue で追加する。

function M.setup()
  vim.api.nvim_create_user_command("OrbitStart", function()
    require("orbit.workspace").start()
  end, {})
end

return M
