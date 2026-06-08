local state = require("orbit.workspace.state")

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      state.reset()
      pcall(vim.api.nvim_del_augroup_by_name, "orbit_workspace_state")
    end,
    post_case = function()
      state.reset()
      pcall(vim.api.nvim_del_augroup_by_name, "orbit_workspace_state")
    end,
  },
})

local function create_buffer(opts)
  opts = opts or {}

  local bufnr = vim.api.nvim_create_buf(true, false)

  if opts.buftype ~= nil then
    vim.bo[bufnr].buftype = opts.buftype
  end

  return bufnr
end

local function delete_buffer(bufnr)
  if bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

T["is_file_buffer returns true for normal buffers"] = function()
  local bufnr = create_buffer()

  MiniTest.expect.equality(state.is_file_buffer(bufnr), true)

  delete_buffer(bufnr)
end

T["is_file_buffer returns false for special buffers"] = function()
  local bufnr = create_buffer({ buftype = "nofile" })

  MiniTest.expect.equality(state.is_file_buffer(bufnr), false)

  delete_buffer(bufnr)
end

T["set_last_active_file_bufnr stores file buffer"] = function()
  local bufnr = create_buffer()

  state.set_last_active_file_bufnr(bufnr)

  MiniTest.expect.equality(state.get_last_active_file_bufnr(), bufnr)

  delete_buffer(bufnr)
end

T["set_last_active_file_bufnr does not replace with special buffer"] = function()
  local file_bufnr = create_buffer()
  local special_bufnr = create_buffer({ buftype = "nofile" })

  state.set_last_active_file_bufnr(file_bufnr)
  state.set_last_active_file_bufnr(special_bufnr)

  MiniTest.expect.equality(state.get_last_active_file_bufnr(), file_bufnr)

  delete_buffer(file_bufnr)
  delete_buffer(special_bufnr)
end

T["get_last_active_file_bufnr clears invalid buffer"] = function()
  local bufnr = create_buffer()

  state.set_last_active_file_bufnr(bufnr)
  delete_buffer(bufnr)

  MiniTest.expect.equality(state.get_last_active_file_bufnr(), nil)
end

T["setup_tracking updates last active file buffer on BufEnter"] = function()
  local file_bufnr = create_buffer()
  local special_bufnr = create_buffer({ buftype = "nofile" })
  local original_bufnr = vim.api.nvim_get_current_buf()

  state.setup_tracking()
  vim.api.nvim_set_current_buf(file_bufnr)

  MiniTest.expect.equality(state.get_last_active_file_bufnr(), file_bufnr)

  vim.api.nvim_set_current_buf(special_bufnr)

  MiniTest.expect.equality(state.get_last_active_file_bufnr(), file_bufnr)

  vim.api.nvim_set_current_buf(original_bufnr)
  delete_buffer(file_bufnr)
  delete_buffer(special_bufnr)
end

T["workspace start keeps previous file buffer"] = function()
  local workspace = require("orbit.workspace")
  local file_bufnr = create_buffer()
  local workspace_bufnr = create_buffer()
  local original_bufnr = vim.api.nvim_get_current_buf()
  local original_layout = package.loaded["orbit.workspace.layout"]
  local original_terminal = package.loaded["orbit.workspace.terminal"]
  local original_process = package.loaded["orbit.workspace.process"]

  package.loaded["orbit.workspace.layout"] = {
    create = function()
      return 100
    end,
    focus = function() end,
  }

  package.loaded["orbit.workspace.terminal"] = {
    create = function()
      vim.api.nvim_set_current_buf(workspace_bufnr)
      return workspace_bufnr
    end,
  }

  package.loaded["orbit.workspace.process"] = {
    start = function()
      return 10
    end,
  }

  vim.api.nvim_set_current_buf(file_bufnr)
  workspace.start()

  package.loaded["orbit.workspace.layout"] = original_layout
  package.loaded["orbit.workspace.terminal"] = original_terminal
  package.loaded["orbit.workspace.process"] = original_process

  MiniTest.expect.equality(state.get_last_active_file_bufnr(), file_bufnr)

  vim.api.nvim_set_current_buf(original_bufnr)
  delete_buffer(file_bufnr)
  delete_buffer(workspace_bufnr)
end

return T
