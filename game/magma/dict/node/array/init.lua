local util = require('magma._util')
local update = require('magma.dict.node.array.update')

local function get(node, shift, keyHash, key, notSetValue)
  local entries = node.entries

  for ii = 1, #entries do
    if util.is(key, entries[ii][1]) then
      return entries[ii][2]
    end
  end

  return notSetValue
end

local function newArrayNode(ownerID, entries)
  local node = {ownerID = ownerID, entries = entries}

  node.get = get
  node.update = update

  return node
end

return newArrayNode
