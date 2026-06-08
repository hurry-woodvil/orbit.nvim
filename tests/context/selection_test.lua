local selection_context = require("orbit.context.selection")

local T = MiniTest.new_set()

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

  if opts.buftype ~= nil then
    vim.bo[bufnr].buftype = opts.buftype
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

T["build includes buffer metadata range and selected content"] = function()
  local bufnr = create_buffer({
    name = "selection.lua",
    filetype = "lua",
    lines = {
      "local a = 1",
      "local b = 2",
      "return a + b",
    },
  })

  local context_text, err = selection_context.build(bufnr, {
    line1 = 2,
    line2 = 3,
    mode = "V",
    range = 2,
  })

  MiniTest.expect.equality(err, nil)
  MiniTest.expect.equality(
    context_text,
    table.concat({
      "# Selection Context",
      "",
      "Name: " .. vim.api.nvim_buf_get_name(bufnr),
      "Filetype: lua",
      "Range: L2-L3",
      "",
      "```lua",
      "local b = 2\nreturn a + b",
      "```",
    }, "\n")
  )

  delete_buffer(bufnr)
end

T["build normalizes reversed range"] = function()
  local bufnr = create_buffer({
    filetype = "text",
    lines = { "one", "two", "three" },
  })

  local context_text = selection_context.build(bufnr, {
    line1 = 3,
    line2 = 2,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(context_text:find("Range: L2-L3", 1, true) ~= nil, true)
  MiniTest.expect.equality(context_text:find("two\nthree", 1, true) ~= nil, true)

  delete_buffer(bufnr)
end

T["build uses no name fallback"] = function()
  local bufnr = create_buffer({
    filetype = "text",
    lines = { "memo" },
  })

  local context_text = selection_context.build(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(vim.tbl_contains(vim.split(context_text, "\n"), "Name: [No Name]"), true)

  delete_buffer(bufnr)
end

T["build returns error without visual selection range"] = function()
  local bufnr = create_buffer({
    lines = { "memo" },
  })

  local context_text, err = selection_context.build(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "v",
    range = 0,
  })

  MiniTest.expect.equality(context_text, nil)
  MiniTest.expect.equality(err, "visual selection が存在しません")

  delete_buffer(bufnr)
end

T["build returns error for invalid buffer"] = function()
  local bufnr = create_buffer()
  delete_buffer(bufnr)

  local context_text, err = selection_context.build(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(context_text, nil)
  MiniTest.expect.equality(err, "送信対象 buffer が存在しません")
end

T["build returns error for special buffer"] = function()
  local bufnr = create_buffer({
    buftype = "nofile",
    lines = { "memo" },
  })

  local context_text, err = selection_context.build(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(context_text, nil)
  MiniTest.expect.equality(err, "送信対象 buffer が file buffer ではありません")

  delete_buffer(bufnr)
end

T["build returns error for blockwise selection"] = function()
  local bufnr = create_buffer({
    lines = { "memo" },
  })

  local context_text, err = selection_context.build(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "\22",
    range = 2,
  })

  MiniTest.expect.equality(context_text, nil)
  MiniTest.expect.equality(err, "blockwise selection は送信できません")

  delete_buffer(bufnr)
end

return T
