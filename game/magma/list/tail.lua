local util = require('magma._util')

local function getTailOffset(size)
  local tailOffset

  if size < util.SIZE then
    tailOffset = 0
  else
    tailOffset = bit.lshift(bit.rshift((size - 1), util.SHIFT), util.SHIFT)
  end

  return tailOffset
end

return getTailOffset
