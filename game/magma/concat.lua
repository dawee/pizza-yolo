local curry = require('magma.curry')

local function pushIterator(first, iterator)
  local entry = iterator:next()

  return entry.done
    and first
    or pushIterator(first:push(entry.value[2]), iterator)
end

local function _concat(first, second)
  local iterator = second:iterator()

  return pushIterator(first, iterator)
end

local concat = curry(_concat, 2)

return concat
