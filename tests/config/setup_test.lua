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

T["setup applies user workspace width"] = function()
  config.setup({
    workspace = {
      width = 120,
    },
  })

  MiniTest.expect.equality(config.get().workspace.width, 120)
end

T["setup applies nested provider values"] = function()
  config.setup({
    providers = {
      codex = {
        command = "codex-custom",
      },
    },
  })

  MiniTest.expect.equality(config.get().providers.codex.command, "codex-custom")
end

T["setup keeps unspecified default values"] = function()
  config.setup({
    workspace = {
      width = 120,
    },
  })

  local current = config.get()

  MiniTest.expect.equality(current.workspace.position, "left")
  MiniTest.expect.equality(current.workspace.height, 20)
  MiniTest.expect.equality(current.default_provider, "codex")
end

T["setup accepts empty opts"] = function()
  config.setup({})

  local current = config.get()

  MiniTest.expect.equality(current.workspace.width, 80)
  MiniTest.expect.equality(current.providers.codex.command, "codex")
end

return T
