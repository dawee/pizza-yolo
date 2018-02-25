local curry = require('magma.curry')

local function _merge(dict2, dict1)
  local iterator = dict2:iterator()
  local merged = dict1

  repeat
    local entry = iterator:next()

    if not entry.done then
      merged = merged:set(unpack(entry.value))
    end
  until(entry.done)

  return merged
end

local merge = curry(_merge, 2)

return merge
