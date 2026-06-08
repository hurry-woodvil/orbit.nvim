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

local function get_content(bufnr)
  return table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
end

---@param bufnr integer|nil
---@return string|nil context_text
---@return string|nil err
function M.build(bufnr)
  if bufnr == nil or not vim.api.nvim_buf_is_valid(bufnr) then
    return nil, "送信対象 buffer が存在しません"
  end

  local name = get_buffer_name(bufnr)
  local filetype = get_filetype(bufnr)
  local content = get_content(bufnr)

  return table.concat({
    "# Buffer Context",
    "",
    "Name: " .. name,
    "Filetype: " .. filetype,
    "",
    "```" .. filetype,
    content,
    "```",
  }, "\n"),
    nil
end

return M
