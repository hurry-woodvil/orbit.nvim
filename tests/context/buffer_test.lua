local buffer_context = require("orbit.context.buffer")

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

T["build includes buffer name filetype and content"] = function()
  local bufnr = create_buffer({
    name = "test-buffer.lua",
    filetype = "lua",
    lines = {
      "local value = 1",
      "return value",
    },
  })

  local context_text, err = buffer_context.build(bufnr)

  MiniTest.expect.equality(err, nil)
  MiniTest.expect.equality(
    context_text,
    table.concat({
      "# Buffer Context",
      "",
      "Name: " .. vim.api.nvim_buf_get_name(bufnr),
      "Filetype: lua",
      "",
      "```lua",
      "local value = 1\nreturn value",
      "```",
    }, "\n")
  )

  delete_buffer(bufnr)
end

T["build supports unsaved named buffer"] = function()
  local bufnr = create_buffer({
    name = "unsaved.md",
    filetype = "markdown",
    lines = { "# Draft" },
  })

  local context_text = buffer_context.build(bufnr)
  local lines = vim.split(context_text, "\n")

  MiniTest.expect.equality(
    vim.tbl_contains(lines, "Name: " .. vim.api.nvim_buf_get_name(bufnr)),
    true
  )
  MiniTest.expect.equality(vim.tbl_contains(lines, "Filetype: markdown"), true)
  MiniTest.expect.equality(context_text:find("# Draft", 1, true) ~= nil, true)

  delete_buffer(bufnr)
end

T["build uses no name fallback"] = function()
  local bufnr = create_buffer({
    filetype = "text",
    lines = { "memo" },
  })

  local context_text = buffer_context.build(bufnr)

  MiniTest.expect.equality(vim.tbl_contains(vim.split(context_text, "\n"), "Name: [No Name]"), true)

  delete_buffer(bufnr)
end

T["build supports empty buffer"] = function()
  local bufnr = create_buffer({
    name = "empty.txt",
    filetype = "text",
    lines = {},
  })

  local context_text, err = buffer_context.build(bufnr)

  MiniTest.expect.equality(err, nil)
  MiniTest.expect.equality(
    context_text,
    table.concat({
      "# Buffer Context",
      "",
      "Name: " .. vim.api.nvim_buf_get_name(bufnr),
      "Filetype: text",
      "",
      "```text",
      "",
      "```",
    }, "\n")
  )

  delete_buffer(bufnr)
end

T["build returns error for invalid buffer"] = function()
  local bufnr = create_buffer()
  delete_buffer(bufnr)

  local context_text, err = buffer_context.build(bufnr)

  MiniTest.expect.equality(context_text, nil)
  MiniTest.expect.equality(err, "送信対象 buffer が存在しません")
end

return T
