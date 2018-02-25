local isList = require('magma.islist')
local curry = require('magma.curry')

local function _push(value, data)
  if not isList(data) then
    return data
  end

  return data:push(value)
end

local push = curry(_push, 2)

return push
