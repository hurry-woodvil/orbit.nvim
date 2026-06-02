local T = MiniTest.new_set()

T["mini.test runner works"] = function()
  MiniTest.expect.equality(type(MiniTest.run), "function")
end

return T
