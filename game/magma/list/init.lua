local emptyList = require('magma.list.empty')

local function list(tab)
  local newList = emptyList()

  if not tab then
    return newList
  end

  for __, value in pairs(tab) do
    newList = newList:push(value)
  end

  return newList
end

return list
