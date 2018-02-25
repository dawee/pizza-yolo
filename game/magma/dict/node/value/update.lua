local util = require('magma._util')
local mergeIntoNode = require('magma.dict.node.merge')
local NOT_SET = require('magma._util').NOT_SET

local function valueNodeUpdate(node, ownerID, shift, keyHash, key, value, didChangeSize, didAlter)
  local newValueNode = require('magma.dict.node.value')

  local removed = value == NOT_SET
  local keyMatch = util.is(key, node.entry[1])

  if (keyMatch and value == node.entry[2] or removed) then
    return node;
  end

  util.setRef(didAlter)

  if removed then
    util.setRef(didChangeSize)
    return
  end

  if keyMatch then
    if ownerID and (ownerID == node.ownerID) then
      node.entry[2] = value
      return node
    end

    return newValueNode(ownerID, node.keyHash, {key, value})
  end

  util.setRef(didChangeSize)
  return mergeIntoNode(node, ownerID, shift, util.hash(key), {key, value})
end

return valueNodeUpdate
