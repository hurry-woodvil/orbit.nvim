local M = {}

-- Codex workspace 用 terminal buffer の作成・削除を担当する。

function M.create()
  vim.cmd("enew")

  local bufnr = vim.api.nvim_get_current_buf()
  vim.bo[bufnr].bufhidden = "wipe"

  require("orbit.workspace.state").set_bufnr(bufnr)
end

return M
