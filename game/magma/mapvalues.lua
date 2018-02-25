local curry = require('magma.curry')
local dict = require('magma.dict')
local isDict = require('magma.isdict')

local function mapIteratorValues(newDict, predicate, iterator)
  local entry = iterator:next()

  if entry.done then
    return newDict
  end

  return mapIteratorValues(
    newDict:set(
      entry.value[1],
      predicate(entry.value[2], entry.value[1])
    ),
    predicate,
    iterator
  )
end

local function _mapValues(predicate, iteratee)
  if not isDict(iteratee) then
    return iteratee
  end

  local iterator = iteratee:iterator()

  return mapIteratorValues(dict(), predicate, iterator)
end

local mapValues = curry(_mapValues, 2)

return mapValues
