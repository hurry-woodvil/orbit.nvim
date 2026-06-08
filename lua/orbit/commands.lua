local M = {}

-- orbit.nvim の user command 定義を集約する。
-- 個別 command は対応する Task Issue で追加する。

---orbit.nvim の user command を定義する。
function M.setup()
  -- setup() は plugin/orbit.lua と user config の両方から複数回呼ばれる可能性がある。
  -- TODO: command lifecycle が必要になった段階で、登録済み state 管理へ切り出す。
  vim.api.nvim_create_user_command("OrbitStart", function()
    require("orbit.workspace").start()
  end, { force = true })

  vim.api.nvim_create_user_command("OrbitRelease", function()
    require("orbit.workspace").release()
  end, { force = true })

  vim.api.nvim_create_user_command("OrbitSendBuffer", function()
    local ok, err = require("orbit.workspace").send_buffer()

    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end, { force = true })

  vim.api.nvim_create_user_command("OrbitSendSelection", function(opts)
    local ok, err = require("orbit.workspace").send_selection({
      bufnr = vim.api.nvim_get_current_buf(),
      line1 = opts.line1,
      line2 = opts.line2,
      mode = vim.fn.visualmode(),
      range = opts.range,
    })

    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end, { force = true, range = true })
end

return M
