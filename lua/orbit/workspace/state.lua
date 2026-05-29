local M = {}

-- Codex workspace の state 管理を担当する。

local state = {
  win_id = nil,
  bufnr = nil,
  job_id = nil,
}

function M.set_win_id(win_id)
  state.win_id = win_id
end

function M.set_bufnr(bufnr)
  state.bufnr = bufnr
end

function M.set_job_id(job_id)
  state.job_id = job_id
end

function M.workspace_exists()
  return state.win_id ~= nil and vim.api.nvim_win_is_valid(state.win_id)
end

function M.get_win_id()
  return state.win_id
end

function M.get_bufnr()
  return state.bufnr
end

function M.get_job_id()
  return state.job_id
end

function M.reset()
  state.win_id = nil
  state.bufnr = nil
  state.job_id = nil
end

return M
