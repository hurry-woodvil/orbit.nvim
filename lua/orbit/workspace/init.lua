local M = {}

-- Codex workspace 操作の facade。
-- 詳細な orchestration は後続 Task Issue で実装する。

function M.start()
  require("orbit.workspace.layout").create()
  require("orbit.workspace.terminal").create()
  require("orbit.workspace.process").start()
end

return M
