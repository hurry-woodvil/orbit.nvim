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

---@param bufnr integer|nil
---@param opts { line1: integer|nil, line2: integer|nil, mode: string|nil, range: integer|nil }|nil
---@return string|nil context_text
---@return string|nil err
function M.build(bufnr, opts)
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
  local name = get_buffer_name(bufnr)
  local filetype = get_filetype(bufnr)
  local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false), "\n")

  return table.concat({
    "# Selection Context",
    "",
    "Name: " .. name,
    "Filetype: " .. filetype,
    "Range: L" .. start_line .. "-L" .. end_line,
    "",
    "```" .. filetype,
    content,
    "```",
  }, "\n"),
    nil
end

return M
