local newArrayNode = require('magma.dict.node.array')
local updateNode = require('magma.dict.node.update')
local util = require('magma._util')
local NOT_SET = require('magma._util').NOT_SET

local function updateDict(dict, k, v)
  local newRoot
  local newSize
  local makeDict = require('magma.dict.make')

  if not dict._root then
    if v == NOT_SET then
      return dict
    end

    newSize = 1;
    newRoot = newArrayNode(dict.__ownerID, {{k, v}})
  else
    local didChangeSize = util.makeRef(util.CHANGE_LENGTH)
    local didAlter = util.makeRef(util.DID_ALTER)

    newRoot = updateNode(
      dict._root,
      dict.__ownerID,
      0,
      nil,
      k,
      v,
      didChangeSize,
      didAlter
    )

    if (not didAlter.value) then
      return dict
    end

    newSize = dict.size + (didChangeSize.value and (v == NOT_SET and -1 or 1) or 0);
  end

  if (dict.__ownerID) then
    dict.size = newSize
    dict._root = newRoot
    dict.__hash = undefined
    dict.__altered = true
    return dict
  end

  return newRoot and makeDict(newSize, newRoot) or emptyDict()
end

return updateDict
