local curry = require('magma.curry')
local isDict = require('magma.isdict')
local isTable = require('magma.istable')
local split = require('magma.split')


local cachedKeyPaths = {}

local function getUsingTable(keyTable, iteratee, keyIndex)
  if not isDict(iteratee) then
    return nil
  end

  if keyIndex == #keyTable then
    return iteratee:get(keyTable[keyIndex])
  end

  return getUsingTable(keyTable, iteratee:get(keyTable[keyIndex]), keyIndex + 1)
end

local function _get(key, iteratee)
  if not isDict(iteratee) then
    return nil
  end

  if isTable(key) then
    return getUsingTable(key, iteratee, 1)
  end

  local isKeyPath = key:find('%.')

  if isKeyPath then
    if not cachedKeyPaths[key] then
      cachedKeyPaths[key] = split('%.', key)
    end

    return getUsingTable(cachedKeyPaths[key], iteratee, 1)
  end

  return iteratee:get(key)
end

local get = curry(_get, 2)

return get
