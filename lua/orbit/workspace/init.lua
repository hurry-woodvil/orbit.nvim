local M = {}

-- Codex workspace 操作の facade。
-- 詳細な orchestration は後続 Task Issue で実装する。

---Codex workspace を開始する。
function M.start()
  local state = require("orbit.workspace.state")
  local layout = require("orbit.workspace.layout")
  state.track_current_buffer()
  local last_active_file_bufnr = state.get_last_active_file_bufnr()

  if state.workspace_exists() then
    layout.focus(state.get_win_id())
    return
  end

  local terminal = require("orbit.workspace.terminal")
  local process = require("orbit.workspace.process")

  local win_id = layout.create()
  state.set_win_id(win_id)

  local bufnr = terminal.create()
  state.set_bufnr(bufnr)
  state.set_last_active_file_bufnr(last_active_file_bufnr)

  local job_id, err = process.start()
  if job_id == nil then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  state.set_job_id(job_id)
end

---Codex workspace を release する。
function M.release()
  local state = require("orbit.workspace.state")

  require("orbit.workspace.process").stop(state.get_job_id())
  require("orbit.workspace.layout").close(state.get_win_id())
  require("orbit.workspace.terminal").delete(state.get_bufnr())

  state.reset()
end

---last active file buffer の context を Codex workspace に送信する。
---@return boolean ok
---@return string|nil err
function M.send_buffer()
  local state = require("orbit.workspace.state")
  local context_text, context_err =
    require("orbit.context.buffer").build(state.get_last_active_file_bufnr())

  if context_text == nil then
    return false, context_err
  end

  local ok, send_err = require("orbit.workspace.process").send(state.get_job_id(), context_text)

  if not ok then
    return false, send_err
  end

  return true, nil
end

return M
