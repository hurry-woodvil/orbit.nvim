local M = {}

-- Codex workspace の state 管理を担当する。

---@class OrbitWorkspaceState
---@field win_id integer|nil Codex workspace window id.
---@field bufnr integer|nil Codex workspace buffer id.
---@field job_id integer|nil Codex terminal job/channel id.
local state = {
  win_id = nil,
  bufnr = nil,
  job_id = nil,
}

---@param win_id integer
function M.set_win_id(win_id)
  state.win_id = win_id
end

---@param bufnr integer
function M.set_bufnr(bufnr)
  state.bufnr = bufnr
end

---@param job_id integer
function M.set_job_id(job_id)
  state.job_id = job_id
end

---@return boolean exists true when the workspace window still exists.
function M.workspace_exists()
  return state.win_id ~= nil and vim.api.nvim_win_is_valid(state.win_id)
end

---@return integer|nil win_id Codex workspace window id.
function M.get_win_id()
  return state.win_id
end

---@return integer|nil bufnr Codex workspace buffer id.
function M.get_bufnr()
  return state.bufnr
end

---@return integer|nil job_id Codex terminal job/channel id.
function M.get_job_id()
  return state.job_id
end

---workspace state を初期状態に戻す。
function M.reset()
  state.win_id = nil
  state.bufnr = nil
  state.job_id = nil
end

return M
