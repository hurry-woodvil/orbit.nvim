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
  local state = require("orbit.workspace.state")

  require("orbit.workspace.process").stop(state.get_job_id())
  require("orbit.workspace.layout").close(state.get_win_id())
  require("orbit.workspace.terminal").delete(state.get_bufnr())

  state.reset()
end

return M
