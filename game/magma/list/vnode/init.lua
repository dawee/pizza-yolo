local removeBefore = require('magma.list.vnode.before')

local function newVNode(array, ownerID)
  local vnode = {array = array, ownerID = ownerID}

  vnode.removeBefore = removeBefore

  return vnode
end

return newVNode
