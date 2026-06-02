local config = require("orbit.config")

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

T["reset restores default configuration after setup"] = function()
  config.setup({
    workspace = {
      width = 120,
      height = 40,
    },
    providers = {
      codex = {
        command = "codex-custom",
      },
    },
  })

  config.reset()

  local current = config.get()

  MiniTest.expect.equality(current.workspace.width, 80)
  MiniTest.expect.equality(current.workspace.height, 20)
  MiniTest.expect.equality(current.providers.codex.command, "codex")
end

T["reset can be called multiple times"] = function()
  config.setup({
    workspace = {
      width = 120,
    },
  })

  config.reset()
  config.reset()

  MiniTest.expect.equality(config.get().workspace.width, 80)
end

T["reset prevents state from leaking between cases"] = function()
  MiniTest.expect.equality(config.get().workspace.width, 80)
end

return T
