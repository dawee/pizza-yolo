local curry = require('magma.curry')
local isDict = require('magma.isdict')
local isList = require('magma.islist')

local function reduceIterator(predicate, memo, iterator)
  local entry = iterator:next()

  if entry.done then
    return memo
  end

  return reduceIterator(
    predicate,
    predicate(memo, entry.value[2], entry.value[1]),
    iterator
  )
end

local function _reduce(predicate, initial, iteratee)
  if not isDict(iteratee) and not isList(iteratee) then
    return initial
  end

  return reduceIterator(predicate, initial, iteratee:iterator())
end

local reduce = curry(_reduce, 3)

return reduce
