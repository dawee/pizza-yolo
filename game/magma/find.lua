local curry = require('magma.curry')
local isList = require('magma.islist')
local isDict = require('magma.isdict')
local isFunction = require('magma.isfunction')

local function findInIterator(predicate, iterator)
  local entry = iterator:next()

  if entry.done then
    return nil
  end

  if predicate(entry.value[2], entry.value[1]) then
    return entry.value[2]
  end

  return findInIterator(predicate, iterator)
end

local function createKVPredicate(kvTable)
  return function (toTest)
    if not isDict(toTest) then
      return false
    end

    local result = true

    for key, value in pairs(kvTable) do
      result = toTest:get(key) == value

      if not result then
        break
      end
    end

    return result
  end
end

local function _find(predicateOrKVTable, iteratee)
  if not isList(iteratee) and not isDict(iteratee) then
    return nil
  end

  local iterator = iteratee:iterator()
  local predicate = isFunction(predicateOrKVTable)
    and predicateOrKVTable
    or createKVPredicate(predicateOrKVTable)

  return findInIterator(predicate, iterator)
end

return curry(_find, 2)
