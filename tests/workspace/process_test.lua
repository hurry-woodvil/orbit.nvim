local config = require("orbit.config")
local process = require("orbit.workspace.process")

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

local function capture_start()
  local original_termopen = vim.fn.termopen
  local original_cmd = vim.cmd
  local called_command
  local called_vim_command

  vim.fn.termopen = function(command)
    called_command = command
    return 10
  end

  vim.cmd = function(command)
    called_vim_command = command
  end

  local ok, job_id_or_err, err = pcall(process.start)

  vim.fn.termopen = original_termopen
  vim.cmd = original_cmd

  if not ok then
    error(job_id_or_err)
  end

  return {
    job_id = job_id_or_err,
    err = err,
    command = called_command,
    vim_command = called_vim_command,
  }
end

T["start uses default provider command"] = function()
  local result = capture_start()

  MiniTest.expect.equality(result.command, { "codex" })
  MiniTest.expect.equality(result.job_id, 10)
  MiniTest.expect.equality(result.err, nil)
  MiniTest.expect.equality(result.vim_command, "startinsert")
end

T["start uses configured provider command and args"] = function()
  config.setup({
    default_provider = "test",
    providers = {
      test = {
        command = "sh",
        args = { "-c", "echo test" },
      },
    },
  })

  MiniTest.expect.equality(capture_start().command, { "sh", "-c", "echo test" })
end

T["start uses configured provider command without args"] = function()
  config.setup({
    default_provider = "test",
    providers = {
      test = {
        command = "sh",
        args = {},
      },
    },
  })

  MiniTest.expect.equality(capture_start().command, { "sh" })
end

T["start returns error when terminal job cannot start"] = function()
  local original_termopen = vim.fn.termopen
  local original_cmd = vim.cmd
  local called_vim_command

  vim.fn.termopen = function()
    return 0
  end

  vim.cmd = function(command)
    called_vim_command = command
  end

  local job_id, err = process.start()

  vim.fn.termopen = original_termopen
  vim.cmd = original_cmd

  MiniTest.expect.equality(job_id, nil)
  MiniTest.expect.equality(err, "Codex process を起動できませんでした")
  MiniTest.expect.equality(called_vim_command, nil)
end

return T
