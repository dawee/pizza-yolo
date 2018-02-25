local util = require('magma._util')
local NOT_SET = require('magma._util').NOT_SET

local function updateHashCollisionNode(node, ownerID, shift, keyHash, key, value, didChangeSize, didAlter)
  local mergeIntoNode = require('magma.dict.node.merge')
  local newValueNode = require('magma.dict.node.value')
  local newHashCollisionNode = require('magma.dict.node.collision')

  if keyHash == nil then
    keyHash = util.hash(key)
  end

  local removed = value == NOT_SET

  if not (keyHash == node.keyHash) then
    if removed then
      return node
    end

    util.setRef(didAlter)
    util.setRef(didChangeSize)
    return mergeIntoNode(node, ownerID, shift, keyHash, {key, value})
  end

  local entries = node.entries

  local idx = 1
  local len = #entries

  while idx <= len do
    if util.is(key, entries[idx][1]) then
      break
    end

    idx = idx + 1
  end

  local exists = idx <= len

  if (exists and (entries[idx][2] == value) or removed) then
    return node
  end

  util.setRef(didAlter)

  if removed or not exists then
    util.setRef(didChangeSize)
  end

  if removed and (len == 2) then
    return newValueNode(ownerID, node.keyHash, entries[bit.bxor(idx, 1)])
  end

  local isEditable = ownerID and (ownerID == node.ownerID)
  local newEntries = isEditable and entries or util.arrCopy(entries)

  if exists then
    if removed then
      local entryToRemove = newEntries[#newEntries]

      if not (idx == len) then
        newEntries[idx] = entryToRemove
      end

      table.remove(newEntries, #newEntries)
    else
      newEntries[idx] = {key, value}
    end
  else
    newEntries[#newEntries + 1] = {key, value}
  end

  if isEditable then
    node.entries = newEntries
    return node
  end

  return newHashCollisionNode(ownerID, node.keyHash, newEntries)
end

return updateHashCollisionNode
