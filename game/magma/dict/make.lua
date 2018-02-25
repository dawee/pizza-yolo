local update = require('magma.dict.update')
local newDictIterator = require('magma.dict.iterator')

local function get(dict, k, notSetValue)
  if dict._root then
    return dict._root:get(0, undefined, k, notSetValue)
  else
    return notSetValue
  end
end

local function makeDict(size, root, ownerID, hash)
  local dict = {}

  dict.root = dict
  dict.set = update
  dict.get = get
  dict.iterator = newDictIterator

  dict.size = size
  dict._root = root
  dict.__ownerID = ownerID
  dict.__hash = hash
  dict.__altered = false
  dict.__type = 'dict'

  return dict
end

return makeDict
