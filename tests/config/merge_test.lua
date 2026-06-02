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

T["merge overrides specified user values"] = function()
  config.setup({
    workspace = {
      width = 120,
    },
  })

  MiniTest.expect.equality(config.get().workspace.width, 120)
end

T["merge keeps unspecified default values"] = function()
  config.setup({
    workspace = {
      width = 120,
    },
  })

  local current = config.get()

  MiniTest.expect.equality(current.workspace.position, "left")
  MiniTest.expect.equality(current.workspace.height, 20)
  MiniTest.expect.equality(current.providers.codex.command, "codex")
end

T["merge combines nested tables"] = function()
  config.setup({
    providers = {
      codex = {
        command = "codex-custom",
      },
    },
  })

  local current = config.get()

  MiniTest.expect.equality(current.providers.codex.command, "codex-custom")
  MiniTest.expect.equality(current.providers.codex.args, {})
end

T["merge replaces array-like tables with user values"] = function()
  config.setup({
    providers = {
      codex = {
        args = { "--fast" },
      },
    },
  })

  MiniTest.expect.equality(config.get().providers.codex.args, { "--fast" })
end

T["merge uses default configuration when opts is nil"] = function()
  config.setup(nil)

  local current = config.get()

  MiniTest.expect.equality(current.default_provider, "codex")
  MiniTest.expect.equality(current.workspace.width, 80)
  MiniTest.expect.equality(current.providers.codex.command, "codex")
end

T["merge does not mutate default configuration"] = function()
  config.setup({
    workspace = {
      width = 120,
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
  MiniTest.expect.equality(current.providers.codex.command, "codex")
end

T["merge does not mutate nested default tables"] = function()
  config.setup({
    providers = {
      codex = {
        args = { "--fast" },
      },
    },
  })

  config.reset()

  MiniTest.expect.equality(config.get().providers.codex.args, {})
end

return T
