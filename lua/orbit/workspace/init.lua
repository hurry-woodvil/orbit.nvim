local M = {}

-- Codex workspace 操作の facade。
-- 詳細な orchestration は後続 Task Issue で実装する。

function M.start()
  local state = require("orbit.workspace.state")
  local layout = require("orbit.workspace.layout")

  if state.workspace_exists() then
    layout.focus(state.get_win_id())
    return
  end

  layout.create()
  require("orbit.workspace.terminal").create()
  require("orbit.workspace.process").start()
end

function M.release()
  vim.notify("OrbitRelease はまだ placeholder です", vim.log.levels.INFO)
end

return M
