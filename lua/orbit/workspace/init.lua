local M = {}

-- Codex workspace 操作の facade。
-- 詳細な orchestration は後続 Task Issue で実装する。

function M.start()
  require("orbit.workspace.layout").create()
end

return M
