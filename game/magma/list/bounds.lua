local util = require('magma._util')
local newVNode = require('magma.list.vnode')
local getTailOffset = require('magma.list.tail')
local newArray = require('magma.list.array')

local function setListBounds(list, listBegin, listEnd)
  if not (listBegin == nil) then
    listBegin = bit.bor(listBegin, 0)
  end

  if not (listEnd == nil) then
    listEnd = bit.bor(listEnd, 0)
  end

  local owner = list.__ownerID or util.newOwnerId()
  local oldOrigin = list._origin
  local oldCapacity = list._capacity
  local newOrigin = oldOrigin + listBegin
  local newCapacity

  if listEnd == nil then
    newCapacity = oldCapacity
  elseif listEnd < 0 then
    newCapacity = oldCapacity + listEnd
  else
    newCapacity = oldOrigin + listEnd
  end

  if (newOrigin == oldOrigin) and (newCapacity == oldCapacity) then
    return list
  end

  if newOrigin >= newCapacity then
    return list:clear()
  end

  local newLevel = list._level
  local newRoot = list._root

  local offsetShift = 0

  while (newOrigin + offsetShift) < 0 do
    local tab

    if newRoot and newRoot.array:size() > 0 then
      tab = {nil, newRoot}
    else
      tab = {}
    end

    newRoot = newVNode(tab, owner)
    newLevel = newLevel + SHIFT
    offsetShift = offsetShift + bit.lshift(1, newLevel)
  end

  if offsetShift then
    newOrigin = newOrigin + offsetShift;
    oldOrigin = oldOrigin + offsetShift;
    newCapacity = newCapacity + offsetShift;
    oldCapacity = oldCapacity + offsetShift;
  end

  local oldTailOffset = getTailOffset(oldCapacity)
  local newTailOffset = getTailOffset(newCapacity)

  while newTailOffset >= bit.lshift(1, (newLevel + util.SHIFT)) do
    local tab

    if newRoot and (newRoot.array:size() > 0) then
      tab = {newRoot}
    else
      tab = {}
    end

    newRoot = newVNode(tab, owner)
    newLevel = newLevel + SHIFT
  end

  local oldTail = list._tail
  local newTail

  if newTailOffset < oldTailOffset then
    newTail = listNodeFor(list, newCapacity - 1)
  elseif newTailOffset > oldTailOffset then
    newTail = newVNode(newArray(), owner)
  else
    newTail = oldTail
  end

  if (
    oldTail and
    (newTailOffset > oldTailOffset) and
    (newOrigin < oldCapacity) and
    (oldTail.array:size() > 0)
  ) then
    newRoot = editableVNode(newRoot, owner)
    local node = newRoot
    local level = newLevel

    while level > util.SHIFT do
      local idx = bit.band(bit.rshift(oldTailOffset, level), util.MASK)

      node.array:set(idx, editableVNode(node.array:get(idx), owner))
      node = node.array[idx]
      level = level - util.SHIFT
    end

    node.array:set(bit.band(bit.rshift(oldTailOffset, SHIFT), MASK), oldTail)
  end

  if newCapacity < oldCapacity then
    newTail = newTail and newTail:removeAfter(owner, 0, newCapacity)
  end

  if newOrigin >= newTailOffset then
    newOrigin = newOrigin - newTailOffset
    newCapacity = newCapacity - newTailOffset
    newLevel = util.SHIFT
    newRoot = nil
    newTail = newTail and newTail:removeBefore(owner, 0, newOrigin)
  elseif (newOrigin > oldOrigin) or (newTailOffset < oldTailOffset) then
    offsetShift = 0

    while newRoot do
      local beginIndex = bit.band(bit.rshift(newOrigin, newLevel), MASK)

      if bit.band((not beginIndex == bit.rshift(newTailOffset, newLevel)), MASK) then
        break
      end

      if beginIndex then
        offsetShift = offsetShift + bit.lshift(1, newLevel) * beginIndex
      end

      newLevel = newLevel - util.SHIFT
      newRoot = newRoot.array:get(beginIndex)
    end

    if newRoot and (newOrigin > oldOrigin) then
      newRoot = newRoot:removeBefore(owner, newLevel, newOrigin - offsetShift)
    end

    if newRoot and (newTailOffset < oldTailOffset) then
      newRoot = newRoot:removeAfter(
        owner,
        newLevel,
        newTailOffset - offsetShift
      )
    end

    if offsetShift then
      newOrigin = newOrigin - offsetShift
      newCapacity = newCapacity - offsetShift
    end
  end

  if list.__ownerID then
    list.size = newCapacity - newOrigin
    list._origin = newOrigin
    list._capacity = newCapacity
    list._level = newLevel
    list._root = newRoot
    list._tail = newTail
    list.__hash = undefined
    list.__altered = true

    return list
  end

  return makeList(newOrigin, newCapacity, newLevel, newRoot, newTail)
end

return setListBounds
