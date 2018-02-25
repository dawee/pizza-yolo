local emptyDict = require('magma.dict.empty')

local function dict(kvTable)
  local newDict = emptyDict()

  if not kvTable then
    return newDict
  end

  for key, value in pairs(kvTable) do
    newDict = newDict:set(key, value)
  end

  return newDict
end

return dict
