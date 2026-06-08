local M = {}

local function get_buffer_name(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)

  if name == "" then
    return "[No Name]"
  end

  return name
end

local function get_filetype(bufnr)
  return vim.bo[bufnr].filetype
end

local function is_file_buffer(bufnr)
  return vim.bo[bufnr].buftype == ""
end

local function normalize_range(line1, line2)
  if line1 > line2 then
    return line2, line1
  end

  return line1, line2
end

local function normalize_mode(mode)
  if mode == "V" then
    return "line"
  end

  return "char"
end

---@param bufnr integer|nil
---@param opts { line1: integer|nil, line2: integer|nil, mode: string|nil, range: integer|nil }|nil
---@return table|nil selection
---@return string|nil err
function M.get_selection(bufnr, opts)
  opts = opts or {}

  if opts.range ~= 2 or opts.line1 == nil or opts.line2 == nil then
    return nil, "visual selection が存在しません"
  end

  if opts.mode == "\22" then
    return nil, "blockwise selection は送信できません"
  end

  if bufnr == nil or not vim.api.nvim_buf_is_valid(bufnr) then
    return nil, "送信対象 buffer が存在しません"
  end

  if not is_file_buffer(bufnr) then
    return nil, "送信対象 buffer が file buffer ではありません"
  end

  local start_line, end_line = normalize_range(opts.line1, opts.line2)
  local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false), "\n")

  return {
    bufnr = bufnr,
    mode = normalize_mode(opts.mode),
    start_line = start_line,
    end_line = end_line,
    name = get_buffer_name(bufnr),
    filetype = get_filetype(bufnr),
    content = content,
  },
    nil
end

---@param selection { name: string, filetype: string, start_line: integer, end_line: integer, content: string }
---@return string context_text
function M.build(selection)
  return table.concat({
    "# Selection Context",
    "",
    "Name: " .. selection.name,
    "Filetype: " .. selection.filetype,
    "Range: L" .. selection.start_line .. "-L" .. selection.end_line,
    "",
    "```" .. selection.filetype,
    selection.content,
    "```",
  }, "\n")
end

return M
