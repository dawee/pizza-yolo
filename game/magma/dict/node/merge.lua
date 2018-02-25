local newBitmapIndexedNode = require('magma.dict.node.bitmap')
local newHashCollisionNode = require('magma.dict.node.collision')
local SIZE = require('magma._util').SIZE
local MASK = require('magma._util').MASK
local SHIFT = require('magma._util').SHIFT

local function mergeIntoNode(node, ownerID, shift, keyHash, entry, newValueNode)
  local newValueNode = require('magma.dict.node.value')

  if node.keyHash == keyHash then
    return newHashCollisionNode(ownerID, keyHash, {node.entry, entry});
  end

  local idx1
  local idx2

  if shift == 0 then
    idx1 = bit.band(node.keyHash, MASK)
    idx2 = bit.band(keyHash, MASK)
  else
    idx1 = bit.band(bit.rshift(node.keyHash, shift), MASK)
    idx2 = bit.band(bit.rshift(keyHash, shift), MASK)
  end

  if idx1 == idx2 then
    nodes = {mergeIntoNode(node, ownerID, shift + SHIFT, keyHash, entry)}
  else
    local newNode = newValueNode(ownerID, keyHash, entry)

    if idx1 < idx2 then
      nodes = {node, newNode}
    else
      nodes = {newNode, node}
    end
  end

  return newBitmapIndexedNode(ownerID, bit.bor(bit.lshift(1, idx1), bit.lshift(1, idx2)), nodes);
end

return mergeIntoNode
