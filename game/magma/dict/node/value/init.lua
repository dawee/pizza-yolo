local util = require('magma._util')
local update = require('magma.dict.node.value.update')

local function get(node, shift, keyHash, key, notSetValue)
  if util.is(key, node.entry[1]) then
    return node.entry[2]
  else
    return notSetValue
  end
end

local function newValueNode(ownerID, keyHash, entry)
  local node = {ownerID = ownerID, keyHash = keyHash, entry = entry}

  node.get = get
  node.update = update

  return node
end

return newValueNode
