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

return M
