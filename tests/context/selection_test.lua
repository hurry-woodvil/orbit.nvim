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

T["get_selection returns linewise selection"] = function()
  local bufnr = create_buffer({
    name = "selection.lua",
    filetype = "lua",
    lines = {
      "local a = 1",
      "local b = 2",
      "return a + b",
    },
  })

  local selection, err = selection_context.get_selection(bufnr, {
    line1 = 2,
    line2 = 3,
    mode = "V",
    range = 2,
  })

  MiniTest.expect.equality(err, nil)
  MiniTest.expect.equality(selection.mode, "line")
  MiniTest.expect.equality(selection.start_line, 2)
  MiniTest.expect.equality(selection.end_line, 3)
  MiniTest.expect.equality(selection.name, vim.api.nvim_buf_get_name(bufnr))
  MiniTest.expect.equality(selection.filetype, "lua")
  MiniTest.expect.equality(selection.content, "local b = 2\nreturn a + b")

  delete_buffer(bufnr)
end

T["get_selection returns charwise selection as line range"] = function()
  local bufnr = create_buffer({
    filetype = "text",
    lines = {
      "before",
      "selected",
      "after",
    },
  })

  local selection, err = selection_context.get_selection(bufnr, {
    line1 = 2,
    line2 = 2,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(err, nil)
  MiniTest.expect.equality(selection.mode, "char")
  MiniTest.expect.equality(selection.start_line, 2)
  MiniTest.expect.equality(selection.end_line, 2)
  MiniTest.expect.equality(selection.content, "selected")

  delete_buffer(bufnr)
end

T["build includes buffer metadata range and selected content"] = function()
  local context_text = selection_context.build({
    name = "selection.lua",
    filetype = "lua",
    start_line = 2,
    end_line = 3,
    content = "local b = 2\nreturn a + b",
  })

  MiniTest.expect.equality(
    context_text,
    table.concat({
      "# Selection Context",
      "",
      "Name: selection.lua",
      "Filetype: lua",
      "Range: L2-L3",
      "",
      "```lua",
      "local b = 2\nreturn a + b",
      "```",
    }, "\n")
  )
end

T["get_selection normalizes reversed range"] = function()
  local bufnr = create_buffer({
    filetype = "text",
    lines = { "one", "two", "three" },
  })

  local selection = selection_context.get_selection(bufnr, {
    line1 = 3,
    line2 = 2,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(selection.start_line, 2)
  MiniTest.expect.equality(selection.end_line, 3)
  MiniTest.expect.equality(selection.content, "two\nthree")

  delete_buffer(bufnr)
end

T["get_selection uses no name fallback"] = function()
  local bufnr = create_buffer({
    filetype = "text",
    lines = { "memo" },
  })

  local selection = selection_context.get_selection(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(selection.name, "[No Name]")

  delete_buffer(bufnr)
end

T["get_selection returns error without visual selection range"] = function()
  local bufnr = create_buffer({
    lines = { "memo" },
  })

  local selection, err = selection_context.get_selection(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "v",
    range = 0,
  })

  MiniTest.expect.equality(selection, nil)
  MiniTest.expect.equality(err, "visual selection が存在しません")

  delete_buffer(bufnr)
end

T["get_selection returns error for invalid buffer"] = function()
  local bufnr = create_buffer()
  delete_buffer(bufnr)

  local selection, err = selection_context.get_selection(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(selection, nil)
  MiniTest.expect.equality(err, "送信対象 buffer が存在しません")
end

T["get_selection returns error for special buffer"] = function()
  local bufnr = create_buffer({
    buftype = "nofile",
    lines = { "memo" },
  })

  local selection, err = selection_context.get_selection(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "v",
    range = 2,
  })

  MiniTest.expect.equality(selection, nil)
  MiniTest.expect.equality(err, "送信対象 buffer が file buffer ではありません")

  delete_buffer(bufnr)
end

T["get_selection returns error for blockwise selection"] = function()
  local bufnr = create_buffer({
    lines = { "memo" },
  })

  local selection, err = selection_context.get_selection(bufnr, {
    line1 = 1,
    line2 = 1,
    mode = "\22",
    range = 2,
  })

  MiniTest.expect.equality(selection, nil)
  MiniTest.expect.equality(err, "blockwise selection は送信できません")

  delete_buffer(bufnr)
end

return T
