local M = {}

---@class OrbitConfig
---@field default_provider string
---@field providers table<string, OrbitProviderConfig>
---@field workspace OrbitWorkspaceConfig

---@class OrbitProviderConfig
---@field command string
---@field args string[]

---@class OrbitWorkspaceConfig
---@field position "left"|"right"|"top"|"bottom"
---@field width integer
---@field height integer

return M
