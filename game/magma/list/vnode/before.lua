local util = require('magma._util')
local newArray = require('magma.list.array')

local function removeBefore(vnode, ownerID, level, index)
  local newVNode = require('magma.list.vnode')

  if (((index == level) and bit.lshift(1, level) or 0) or vnode.array:size() == 0) then
    return vnode
  end

  local originIndex = bit.band(bit.rshift(index, level), util.MASK)

  if originIndex >= vnode.array:size() then
    return newVNode(newArray(), ownerID)
  end

  local removingFirst = (originIndex == 0)

  local newChild

  if level > 0 then
    local oldChild = vnode.array:get(originIndex)

    newChild = oldChild and oldChild:removeBefore(ownerID, level - util.SHIFT, index)

    if (newChild == oldChild) and removingFirst then
      return vnode
    end
  end

  if removingFirst and not newChild then
    return vnode
  end

  local editable = editableVNode(vnode, ownerID)

  if not removingFirst then
    for ii = 0, (originIndex - 1) do
      editable.array:set(ii, nil)
    end
  end

  if newChild then
    editable.array:set(originIndex, newChild)
  end

  return editable
end

return removeBefore
