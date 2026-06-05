local config = require("orbit.config")
local layout = require("orbit.workspace.layout")

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      config.reset()
    end,
    post_case = function()
      config.reset()
    end,
  },
})

local function capture_create_layout()
  local original_cmd = vim.cmd
  local original_get_current_win = vim.api.nvim_get_current_win
  local original_win_set_width = vim.api.nvim_win_set_width
  local original_win_set_height = vim.api.nvim_win_set_height
  local called_command
  local width_call
  local height_call

  vim.cmd = function(command)
    called_command = command
  end

  vim.api.nvim_get_current_win = function()
    return 100
  end

  vim.api.nvim_win_set_width = function(win_id, width)
    width_call = { win_id = win_id, width = width }
  end

  vim.api.nvim_win_set_height = function(win_id, height)
    height_call = { win_id = win_id, height = height }
  end

  local ok, err = pcall(layout.create)

  vim.cmd = original_cmd
  vim.api.nvim_get_current_win = original_get_current_win
  vim.api.nvim_win_set_width = original_win_set_width
  vim.api.nvim_win_set_height = original_win_set_height

  if not ok then
    error(err)
  end

  return {
    command = called_command,
    width_call = width_call,
    height_call = height_call,
  }
end

T["create uses default workspace position"] = function()
  local result = capture_create_layout()

  MiniTest.expect.equality(result.command, "topleft vertical new")
  MiniTest.expect.equality(result.width_call, { win_id = 100, width = 80 })
  MiniTest.expect.equality(result.height_call, nil)
end

T["create opens left split"] = function()
  config.setup({
    workspace = {
      position = "left",
    },
  })

  MiniTest.expect.equality(capture_create_layout().command, "topleft vertical new")
end

T["create opens right split"] = function()
  config.setup({
    workspace = {
      position = "right",
    },
  })

  MiniTest.expect.equality(capture_create_layout().command, "botright vertical new")
end

T["create opens top split"] = function()
  config.setup({
    workspace = {
      position = "top",
    },
  })

  MiniTest.expect.equality(capture_create_layout().command, "topleft new")
end

T["create opens bottom split"] = function()
  config.setup({
    workspace = {
      position = "bottom",
    },
  })

  MiniTest.expect.equality(capture_create_layout().command, "botright new")
end

T["create applies workspace width to left split"] = function()
  config.setup({
    workspace = {
      position = "left",
      width = 60,
    },
  })

  local result = capture_create_layout()

  MiniTest.expect.equality(result.width_call, { win_id = 100, width = 60 })
  MiniTest.expect.equality(result.height_call, nil)
end

T["create applies workspace width to right split"] = function()
  config.setup({
    workspace = {
      position = "right",
      width = 70,
    },
  })

  local result = capture_create_layout()

  MiniTest.expect.equality(result.width_call, { win_id = 100, width = 70 })
  MiniTest.expect.equality(result.height_call, nil)
end

T["create applies workspace height to top split"] = function()
  config.setup({
    workspace = {
      position = "top",
      height = 12,
    },
  })

  local result = capture_create_layout()

  MiniTest.expect.equality(result.width_call, nil)
  MiniTest.expect.equality(result.height_call, { win_id = 100, height = 12 })
end

T["create applies workspace height to bottom split"] = function()
  config.setup({
    workspace = {
      position = "bottom",
      height = 16,
    },
  })

  local result = capture_create_layout()

  MiniTest.expect.equality(result.width_call, nil)
  MiniTest.expect.equality(result.height_call, { win_id = 100, height = 16 })
end

return T
