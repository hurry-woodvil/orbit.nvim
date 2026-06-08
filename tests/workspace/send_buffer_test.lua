local state = require("orbit.workspace.state")
local workspace = require("orbit.workspace")

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      state.reset()
    end,
    post_case = function()
      state.reset()
    end,
  },
})

local function create_buffer(opts)
  opts = opts or {}

  local bufnr = vim.api.nvim_create_buf(true, false)
  vim.bo[bufnr].swapfile = false

  if opts.name ~= nil then
    vim.api.nvim_buf_set_name(bufnr, opts.name)
  end

  if opts.filetype ~= nil then
    vim.bo[bufnr].filetype = opts.filetype
  end

  if opts.lines ~= nil then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, opts.lines)
  end

  return bufnr
end

local function delete_buffer(bufnr)
  if bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

local function capture_notify(callback)
  local original_notify = vim.notify
  local calls = {}

  vim.notify = function(message, level)
    table.insert(calls, { message = message, level = level })
  end

  local ok, err = pcall(callback)

  vim.notify = original_notify

  if not ok then
    error(err)
  end

  return calls
end

local function with_process_send(send, callback)
  local process = require("orbit.workspace.process")
  local original_send = process.send

  process.send = send

  local ok, err = pcall(callback)

  process.send = original_send

  if not ok then
    error(err)
  end
end

T["send_buffer sends context for last active file buffer"] = function()
  local bufnr = create_buffer({
    name = "send-buffer.lua",
    filetype = "lua",
    lines = { "return 1" },
  })
  local sent

  state.set_last_active_file_bufnr(bufnr)
  state.set_job_id(10)

  with_process_send(function(job_id, text)
    sent = { job_id = job_id, text = text }
    return true, nil
  end, function()
    local ok, err = workspace.send_buffer()

    MiniTest.expect.equality(ok, true)
    MiniTest.expect.equality(err, nil)
  end)

  MiniTest.expect.equality(sent.job_id, 10)
  MiniTest.expect.equality(
    sent.text:find("Name: " .. vim.api.nvim_buf_get_name(bufnr), 1, true) ~= nil,
    true
  )
  MiniTest.expect.equality(sent.text:find("Filetype: lua", 1, true) ~= nil, true)
  MiniTest.expect.equality(sent.text:find("return 1", 1, true) ~= nil, true)

  delete_buffer(bufnr)
end

T["send_buffer returns error when target buffer is missing"] = function()
  local sent = false
  local ok, err

  with_process_send(function()
    sent = true
    return true, nil
  end, function()
    ok, err = workspace.send_buffer()
  end)

  MiniTest.expect.equality(sent, false)
  MiniTest.expect.equality(ok, false)
  MiniTest.expect.equality(err, "送信対象 buffer が存在しません")
end

T["send_buffer returns error when workspace is not running"] = function()
  local bufnr = create_buffer({
    filetype = "text",
    lines = { "memo" },
  })

  state.set_last_active_file_bufnr(bufnr)

  local ok, err = workspace.send_buffer()

  MiniTest.expect.equality(ok, false)
  MiniTest.expect.equality(err, "Codex workspace が起動していません")

  delete_buffer(bufnr)
end

T["OrbitSendBuffer command is registered and executable"] = function()
  local bufnr = create_buffer({
    filetype = "text",
    lines = { "memo" },
  })
  local sent

  require("orbit").setup()
  state.set_last_active_file_bufnr(bufnr)
  state.set_job_id(10)

  with_process_send(function(job_id, text)
    sent = { job_id = job_id, text = text }
    return true, nil
  end, function()
    vim.cmd("OrbitSendBuffer")
  end)

  MiniTest.expect.equality(vim.api.nvim_get_commands({})["OrbitSendBuffer"] ~= nil, true)
  MiniTest.expect.equality(sent.job_id, 10)
  MiniTest.expect.equality(sent.text:find("memo", 1, true) ~= nil, true)

  delete_buffer(bufnr)
end

T["OrbitSendBuffer command notifies when send fails"] = function()
  local calls = capture_notify(function()
    require("orbit").setup()
    vim.cmd("OrbitSendBuffer")
  end)

  MiniTest.expect.equality(calls, {
    { message = "Codex workspace が起動していません", level = vim.log.levels.ERROR },
  })
end

return T
