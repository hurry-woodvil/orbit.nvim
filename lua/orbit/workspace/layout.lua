local M = {}

-- Codex workspace 用 split layout の作成・終了を担当する。

function M.create()
  vim.cmd("topleft vertical new")

  local win_id = vim.api.nvim_get_current_win()
  require("orbit.workspace.state").set_win_id(win_id)
end

return M
