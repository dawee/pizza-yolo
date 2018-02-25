local makeDict = require('magma.dict.make')

local EMPTY_DICT

local function emptyDict()
  if not EMPTY_DICT then
    EMPTY_DICT = makeDict(0)
  end

  return EMPTY_DICT
end

return emptyDict
