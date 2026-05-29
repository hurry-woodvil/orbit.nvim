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

return M
