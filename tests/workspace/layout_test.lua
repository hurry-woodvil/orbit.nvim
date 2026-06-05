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

local function capture_create_command()
  local original_cmd = vim.cmd
  local called_command

  vim.cmd = function(command)
    called_command = command
  end

  local ok, err = pcall(layout.create)
  vim.cmd = original_cmd

  if not ok then
    error(err)
  end

  return called_command
end

T["create uses default workspace position"] = function()
  MiniTest.expect.equality(capture_create_command(), "topleft vertical new")
end

T["create opens left split"] = function()
  config.setup({
    workspace = {
      position = "left",
    },
  })

  MiniTest.expect.equality(capture_create_command(), "topleft vertical new")
end

T["create opens right split"] = function()
  config.setup({
    workspace = {
      position = "right",
    },
  })

  MiniTest.expect.equality(capture_create_command(), "botright vertical new")
end

T["create opens top split"] = function()
  config.setup({
    workspace = {
      position = "top",
    },
  })

  MiniTest.expect.equality(capture_create_command(), "topleft new")
end

T["create opens bottom split"] = function()
  config.setup({
    workspace = {
      position = "bottom",
    },
  })

  MiniTest.expect.equality(capture_create_command(), "botright new")
end

return T
