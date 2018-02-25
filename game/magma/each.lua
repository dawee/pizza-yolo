local curry = require('magma.curry')
local isList = require('magma.islist')
local isDict = require('magma.isdict')

local function eachIterator(predicate, iterator)
  local entry = iterator:next()

  if entry.done then
    return
  end

  predicate(entry.value[2], entry.value[1])

  return eachIterator(predicate, iterator)
end

local function _each(predicate, iteratee)
  if not isDict(iteratee) and not isList(iteratee) then
    return
  end

  return eachIterator(predicate, iteratee:iterator())
end

local each = curry(_each, 2)

return each
