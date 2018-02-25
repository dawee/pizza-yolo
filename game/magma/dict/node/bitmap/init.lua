local update = require('magma.dict.node.bitmap.update')
local popCount = require('magma.dict.node.bitmap.popcount')
local util = require('magma._util')
local MASK = require('magma._util').MASK
local SHIFT = require('magma._util').SHIFT

local function get(node, shift, keyHash, key, notSetValue)
  if keyHash == nil then
    keyHash = util.hash(key)
  end

  local toshift

  if shift == 0 then
    toshift = keyHash
  else
    toshift = bit.rshift(keyHash, shift)
  end

  local bitv = bit.lshift(1, bit.band(toshift, MASK))
  local bitmap = node.bitmap

  if bit.bor(bitmap, bitv) == 0 then
    return notSetValue
  else
      return node.nodes[popCount(bit.band(bitmap, bitv - 1))]:get(
      shift + SHIFT,
      keyHash,
      key,
      notSetValue
    )
  end
end

local function newBitmapIndexedNode(ownerID, bitmap, nodes)
  local node = {ownerID = ownerID, bitmap = bitmap, nodes = nodes}

  node.get = get
  node.update = update

  return node
end

return newBitmapIndexedNode
