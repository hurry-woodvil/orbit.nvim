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

T["send_selection sends selected context"] = function()
  local bufnr = create_buffer({
    name = "send-selection.lua",
    filetype = "lua",
    lines = {
      "local a = 1",
      "return a",
    },
  })
  local sent

  state.set_job_id(10)

  with_process_send(function(job_id, text)
    sent = { job_id = job_id, text = text }
    return true, nil
  end, function()
    local ok, err = workspace.send_selection({
      bufnr = bufnr,
      line1 = 1,
      line2 = 1,
      mode = "v",
      range = 2,
    })

    MiniTest.expect.equality(ok, true)
    MiniTest.expect.equality(err, nil)
  end)

  MiniTest.expect.equality(sent.job_id, 10)
  MiniTest.expect.equality(
    sent.text:find("Name: " .. vim.api.nvim_buf_get_name(bufnr), 1, true) ~= nil,
    true
  )
  MiniTest.expect.equality(sent.text:find("Range: L1-L1", 1, true) ~= nil, true)
  MiniTest.expect.equality(sent.text:find("local a = 1", 1, true) ~= nil, true)
  MiniTest.expect.equality(sent.text:find("return a", 1, true) == nil, true)

  delete_buffer(bufnr)
end

T["send_selection returns error when selection is missing"] = function()
  local bufnr = create_buffer({
    lines = { "memo" },
  })
  local sent = false
  local ok, err

  state.set_job_id(10)

  with_process_send(function()
    sent = true
    return true, nil
  end, function()
    ok, err = workspace.send_selection({
      bufnr = bufnr,
      line1 = 1,
      line2 = 1,
      mode = "v",
      range = 0,
    })
  end)

  MiniTest.expect.equality(sent, false)
  MiniTest.expect.equality(ok, false)
  MiniTest.expect.equality(err, "visual selection が存在しません")

  delete_buffer(bufnr)
end

T["send_selection returns error when workspace is not running"] = function()
  local bufnr = create_buffer({
    lines = { "memo" },
  })

  local ok, err = workspace.send_selection({
    bufnr = bufnr,
    line1 = 1,
    line2 = 1,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(ok, false)
  MiniTest.expect.equality(err, "Codex workspace が起動していません")

  delete_buffer(bufnr)
end

T["OrbitSendSelection command is registered and executable"] = function()
  local bufnr = create_buffer({
    filetype = "text",
    lines = { "one", "two" },
  })
  local sent

  require("orbit").setup()
  state.set_job_id(10)
  vim.api.nvim_set_current_buf(bufnr)

  with_process_send(function(job_id, text)
    sent = { job_id = job_id, text = text }
    return true, nil
  end, function()
    vim.cmd("1,1OrbitSendSelection")
  end)

  MiniTest.expect.equality(vim.api.nvim_get_commands({})["OrbitSendSelection"] ~= nil, true)
  MiniTest.expect.equality(sent.job_id, 10)
  MiniTest.expect.equality(sent.text:find("Range: L1-L1", 1, true) ~= nil, true)
  MiniTest.expect.equality(sent.text:find("one", 1, true) ~= nil, true)

  delete_buffer(bufnr)
end

T["OrbitSendSelection command notifies when selection is missing"] = function()
  local calls = capture_notify(function()
    require("orbit").setup()
    vim.cmd("OrbitSendSelection")
  end)

  MiniTest.expect.equality(calls, {
    { message = "visual selection が存在しません", level = vim.log.levels.ERROR },
  })
end

return T
