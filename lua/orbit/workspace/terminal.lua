local M = {}

-- Codex workspace 用 terminal buffer の作成・削除を担当する。

---@return integer bufnr Created Codex workspace buffer id.
function M.create()
  vim.cmd("enew")

  local bufnr = vim.api.nvim_get_current_buf()
  vim.bo[bufnr].bufhidden = "wipe"

  return bufnr
end

---@param bufnr integer|nil Codex workspace buffer id.
function M.delete(bufnr)
  if bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

return M
