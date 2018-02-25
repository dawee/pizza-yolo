local util = require('magma._util')
local setListBounds = require('magma.list.bounds')
local newVNode = require('magma.list.vnode')
local getTailOffset = require('magma.list.tail')
local newArray = require('magma.list.array')

local function editableVNode(node, ownerID)
  if ownerID and node and (ownerID == node.ownerID) then
    return node
  end

  local array = newArray()

  if node then
    array = node.array:clone()
  end

  return newVNode(array, ownerID)
end

local function returnTrue()
  return true
end

local function ensureSize(iter)
  if iter.size == nil then
    iter.size = iter:__iterate(returnTrue)
  end

  return iter.size
end

local function wrapIndex(iter, index)
  return index < 0 and (ensureSize(iter) + index) or index
end

local function updateVNode(node, ownerID, level, index, value, didAlter)
  local idx = bit.band(bit.rshift(index, level), util.MASK)
  local nodeHas = node and (idx < node.array:size())

  if not nodeHas and (value == undefined) then
    return node
  end

  local newNode

  if level > 0 then
    local lowerNode = node and node.array:get(idx)
    local newLowerNode = updateVNode(
      lowerNode,
      ownerID,
      level - util.SHIFT,
      index,
      value,
      didAlter
    )

    if newLowerNode == lowerNode then
      return node
    end

    newNode = editableVNode(node, ownerID)
    newNode.array:set(idx, newLowerNode)

    return newNode
  end

  if nodeHas and (node.array:get(idx) == value) then
    return node
  end

  util.setRef(didAlter)

  newNode = editableVNode(node, ownerID)

  if (value == nil) and (idx == newNode.array:size() - 1) then
    newNode.array:pop()
  else
    newNode.array:set(idx, value)
  end

  return newNode
end


local function updateList(list, index, value)
  index = wrapIndex(list, index);

  -- WTF immutable.js ?
  --
  -- if (index !== index) {
  --   return list;
  -- }

  if (index >= list.size) or (index < 0) then
    local function mutate(newList)
      if index < 0 then
        setListBounds(list, index):update(0, value)
      else
        setListBounds(list, 0, index + 1):update(index, value)
      end
    end

    return list:withMutations(mutate)
  end

  index = index + list._origin

  local newTail = list._tail
  local newRoot = list._root
  local didAlter = util.makeRef(util.DID_ALTER)

  if index >= getTailOffset(list._capacity) then
    newTail = updateVNode(newTail, list.__ownerID, 0, index, value, didAlter);
  else
    newRoot = updateVNode(
      newRoot,
      list.__ownerID,
      list._level,
      index,
      value,
      didAlter
    )
  end

  if not didAlter.value then
    return list
  end

  if list.__ownerID then
    list._root = newRoot
    list._tail = newTail
    list.__hash = nil
    list.__altered = true
    return list
  end

  return makeList(list._origin, list._capacity, list._level, newRoot, newTail)
end

return updateList
