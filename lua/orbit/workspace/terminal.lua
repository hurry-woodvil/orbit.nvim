local M = {}

-- Codex workspace 用 terminal buffer の作成・削除を担当する。

function M.create()
  vim.cmd("terminal")

  local bufnr = vim.api.nvim_get_current_buf()
  require("orbit.workspace.state").set_bufnr(bufnr)

  vim.cmd("startinsert")
end

return M
