local util = require('magma._util')
local createNodes = require('magma.dict.node.create')
local SIZE = require('magma._util').SIZE
local NOT_SET = require('magma._util').NOT_SET

local MAX_ARRAY_MAP_SIZE = SIZE / 4

local function updateArrayNode(node, ownerID, shift, keyHash, key, value, didChangeSize, didAlter)
  local newArrayNode = require('magma.dict.node.array')

  local removed = value == NOT_SET
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

  if removed or (not exists) then
    util.setRef(didChangeSize)
  end

  if (removed and (#entries == 1)) then
    return
  end

  if ((not exists) and (not removed) and (#entries >= MAX_ARRAY_MAP_SIZE)) then
    return createNodes(ownerID, entries, key, value)
  end

  local isEditable = ownerID and (ownerID == node.ownerID)
  local newEntries = isEditable and entries or util.arrCopy(entries)

  if exists then
    if removed then
      local removedEntry = newEntries[#newEntries]

      table.remove(newEntries, #newEntries)

      if not (idx == len) then
        newEntries[idx] = removedEntry
      end
    else
      newEntries[idx] = {key, value}
    end
  else
    newEntries[#newEntries + 1] = {key, value}
  end

  if (isEditable) then
    node.entries = newEntries;
    return node;
  end

  return newArrayNode(ownerID, newEntries)
end

return updateArrayNode
