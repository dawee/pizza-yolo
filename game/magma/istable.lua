local isDict = require('magma.isdict')
local isList = require('magma.islist')

local function isTable(value)
  return (type(value) == 'table') and not isDict(value) and not isList(value)
end

return isTable
