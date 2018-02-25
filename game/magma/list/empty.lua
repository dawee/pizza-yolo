local util = require('magma._util')
local makeList = require('magma.list.make')

local EMPTY_LIST

local function emptyList()
  EMPTY_LIST = EMPTY_LIST or makeList(0, 0, util.SHIFT)

  return EMPTY_LIST
end

return emptyList
