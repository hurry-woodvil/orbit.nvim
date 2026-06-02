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

T["get returns default configuration"] = function()
  local current = config.get()

  MiniTest.expect.equality(current.default_provider, "codex")
  MiniTest.expect.equality(current.workspace.position, "left")
  MiniTest.expect.equality(current.workspace.width, 80)
  MiniTest.expect.equality(current.workspace.height, 20)
  MiniTest.expect.equality(current.providers.codex.command, "codex")
end

T["get returns runtime configuration after setup"] = function()
  config.setup({
    workspace = {
      width = 120,
    },
  })

  MiniTest.expect.equality(config.get().workspace.width, 120)
end

T["get returns a copy that cannot mutate runtime configuration"] = function()
  local current = config.get()
  current.workspace.width = 120

  MiniTest.expect.equality(config.get().workspace.width, 80)
end

T["get returns nested copies that cannot mutate runtime configuration"] = function()
  local current = config.get()
  current.providers.codex.command = "codex-mutated"
  table.insert(current.providers.codex.args, "--mutated")

  local next_current = config.get()

  MiniTest.expect.equality(next_current.providers.codex.command, "codex")
  MiniTest.expect.equality(next_current.providers.codex.args, {})
end

return T
