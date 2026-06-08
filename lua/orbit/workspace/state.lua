local M = {}

-- Codex workspace の state 管理を担当する。

---@class OrbitWorkspaceState
---@field win_id integer|nil Codex workspace window id.
---@field bufnr integer|nil Codex workspace buffer id.
---@field job_id integer|nil Codex terminal job/channel id.
---@field last_active_file_bufnr integer|nil Last active file buffer id.
local state = {
  win_id = nil,
  bufnr = nil,
  job_id = nil,
  last_active_file_bufnr = nil,
}

local augroup_name = "orbit_workspace_state"

---@param bufnr integer|nil
---@return boolean
function M.is_file_buffer(bufnr)
  return bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == ""
end

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

---@param bufnr integer|nil
function M.set_last_active_file_bufnr(bufnr)
  if bufnr ~= nil and not M.is_file_buffer(bufnr) then
    return
  end

  state.last_active_file_bufnr = bufnr
end

function M.track_current_buffer()
  M.set_last_active_file_bufnr(vim.api.nvim_get_current_buf())
end

function M.setup_tracking()
  local augroup = vim.api.nvim_create_augroup(augroup_name, { clear = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function()
      M.track_current_buffer()
    end,
  })

  M.track_current_buffer()
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

---@return integer|nil bufnr Last active file buffer id.
function M.get_last_active_file_bufnr()
  if not M.is_file_buffer(state.last_active_file_bufnr) then
    state.last_active_file_bufnr = nil
  end

  return state.last_active_file_bufnr
end

---workspace state を初期状態に戻す。
function M.reset()
  state.win_id = nil
  state.bufnr = nil
  state.job_id = nil
  state.last_active_file_bufnr = nil
end

return M
