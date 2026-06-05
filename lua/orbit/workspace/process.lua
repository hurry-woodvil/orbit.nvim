local M = {}

-- Codex process の起動・終了を担当する。

---@return integer|nil job_id Codex terminal job/channel id.
---@return string|nil err Error message when Codex process could not be started.
function M.start()
  local config = require("orbit.config").get()
  local provider = config.providers[config.default_provider]
  local command = { provider.command }

  for _, arg in ipairs(provider.args or {}) do
    table.insert(command, arg)
  end

  local job_id = vim.fn.termopen(command)

  if job_id <= 0 then
    return nil, "Codex process を起動できませんでした"
  end

  vim.cmd("startinsert")

  return job_id
end

---@param job_id integer|nil Codex terminal job/channel id.
function M.stop(job_id)
  if job_id ~= nil then
    vim.fn.jobstop(job_id)
  end
end

return M
