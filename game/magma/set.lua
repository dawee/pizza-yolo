local curry = require('magma.curry')
local emptyDict = require('magma.dict.empty')
local isDict = require('magma.isdict')
local split = require('magma.split')

local cachedKeyPaths = {}

local function setUsingKeyTable(keyTable, value, dict, keyIndex)
  local key = keyTable[keyIndex]

  if #keyTable == keyIndex then
    return dict:set(key, value)
  end

  local subdict = dict:get(key)

  if not subdict then
    subdict = emptyDict()
  elseif not isDict(subdict) then
    return dict
  end

  return dict:set(key, setUsingKeyTable(keyTable, value, subdict, keyIndex + 1))
end

local function _set(key, value, dict)
  if not dict or not dict.set or not dict.get then
    return dict
  end

  if type(key) == 'table' then
    return setUsingKeyTable(key, value, dict, 1)
  end

  if not type(key) == 'string' then
    return dict
  end

  local isKeyPath = key:find('%.')

  if isKeyPath then
    if not cachedKeyPaths[key] then
      cachedKeyPaths[key] = split('%.', key)
    end

    return setUsingKeyTable(cachedKeyPaths[key], value, dict, 1)
  end

  return dict:set(key, value)
end

local set = curry(_set, 3)

return set
