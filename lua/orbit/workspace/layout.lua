local M = {}

-- Codex workspace 用 split layout の作成・終了を担当する。

function M.create()
  vim.cmd("topleft vertical new")

  local win_id = vim.api.nvim_get_current_win()
  require("orbit.workspace.state").set_win_id(win_id)
end

function M.focus(win_id)
  if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_set_current_win(win_id)
  end
end

function M.close(win_id)
  if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end
end

return M
