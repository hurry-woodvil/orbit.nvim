---@type OrbitConfig
local defaults = {
  default_provider = "codex",
  providers = {
    codex = {
      command = "codex",
      args = {},
    },
  },
  workspace = {
    position = "left",
    width = 80,
    height = 20,
  },
}

return defaults
