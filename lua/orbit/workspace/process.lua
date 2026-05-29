local M = {}

-- Codex process の起動・終了を担当する。

function M.start()
  local job_id = vim.fn.termopen("codex")

  if job_id <= 0 then
    vim.notify("Codex process を起動できませんでした", vim.log.levels.ERROR)
    return
  end

  require("orbit.workspace.state").set_job_id(job_id)
  vim.cmd("startinsert")
end

function M.stop(job_id)
  if job_id ~= nil then
    vim.fn.jobstop(job_id)
  end
end

return M
