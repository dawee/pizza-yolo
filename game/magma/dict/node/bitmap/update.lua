local util = require('magma._util')
local popCount = require('magma.dict.node.bitmap.popcount')
local MASK = require('magma._util').MASK
local SHIFT = require('magma._util').SHIFT
local NOT_SET = require('magma._util').NOT_SET
local SIZE = require('magma._util').SIZE

local MAX_BITMAP_INDEXED_SIZE = SIZE / 2

local function spliceIn(array, idx, val, canEdit)
  local newLen = #array + 1

  if (canEdit and (idx == newLen)) then
    array[idx] = val
    return array
  end

  local newArray = {}
  local after = 0
  local ii = 1

  while ii <= newLen do
    if ii == idx then
      newArray[ii] = val
      after = -1
    else
      newArray[ii] = array[ii + after]
    end

    ii = ii + 1
  end

  return newArray
end

local function updateBitmapIndexedNode(node, ownerID, shift, keyHash, key, value, didChangeSize, didAlter)
  local newBitmapIndexedNode = require('magma.dict.node.bitmap')
  local updateNode = require('magma.dict.node.update')

  if keyHash == nil then
    keyHash = util.hash(key)
  end

  local keyHashFrag

  if shift == 0 then
    keyHashFrag = keyHash
  else
    keyHashFrag = bit.rshift(keyHash, shift)
  end

  local bitv = bit.lshift(1, bit.band(keyHashFrag, MASK))

  local bitmap = node.bitmap;
  local exists = not (bit.band(bitmap, bitv) == 0);

  if ((not exists) and (value == NOT_SET)) then
    return node
  end

  local idx = popCount(bit.band(bitmap, (bitv - 1)));
  local nodes = node.nodes
  local subnode = exists and nodes[idx] or nil
  local newNode = updateNode(
    subnode,
    ownerID,
    shift + SHIFT,
    keyHash,
    key,
    value,
    didChangeSize,
    didAlter
  )

  if newNode == subnode then
    return node
  end

  if ((not exists) and newNode and #nodes >= MAX_BITMAP_INDEXED_SIZE) then
    return expandNodes(ownerID, nodes, bitmap, keyHashFrag, newNode)
  end

  if (
    exists and
    (not newNode) and
    (#nodes == 2) and
    isLeafNode(nodes[bit.bxor(idx, 1)])
  )
  then
    return nodes[bit.bxor(idx, 1)]
  end

  if (exists and newNode and (#nodes == 1) and isLeafNode(newNode)) then
    return newNode
  end

  local isEditable = ownerID and (ownerID == node.ownerID)
  local newBitmap

  if (exists and newNode) then
    newBitmap = bitmap
  elseif(exists and (not newNode)) then
    newBitmap = bit.bxor(bitmap, bitv)
  else
    newBitmap = bit.bor(bitmap, bitv)
  end

  local newNodes

  if exists and newNode then
    newNodes = util.setAt(nodes, idx, newNode, isEditable)
  elseif exists and not newNode then
    newNodes = spliceOut(nodes, idx, isEditable)
  else
    newNodes = spliceIn(nodes, idx, newNode, isEditable)
  end

  if isEditable then
    node.bitmap = newBitmap
    node.nodes = newNodes
    return node
  end

  return newBitmapIndexedNode(ownerID, newBitmap, newNodes)
end

return updateBitmapIndexedNode
