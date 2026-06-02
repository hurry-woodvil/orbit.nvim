vim.opt.runtimepath:prepend(vim.fn.getcwd())

local mini_test_path = vim.env.ORBIT_MINI_TEST_PATH or (vim.fn.stdpath("data") .. "/lazy/mini.test")

if vim.fn.isdirectory(mini_test_path) == 1 then
  vim.opt.runtimepath:prepend(mini_test_path)
end

local MiniTest = require("mini.test")

MiniTest.setup({
  collect = {
    find_files = function()
      return vim.fn.globpath("tests", "**/*_test.lua", true, true)
    end,
  },
  execute = {
    reporter = MiniTest.gen_reporter.stdout(),
  },
})
