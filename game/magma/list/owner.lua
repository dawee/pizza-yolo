local function ensureOwner(list, ownerID)
  local emptyList = require('magma.list.empty')
  local makeList = require('magma.list.make')

  if ownerID == list.__ownerID then
    return list
  end

  if not ownerID then
    if list.size == 0 then
      return emptyList()
    end

    list.__ownerID = ownerID
    list.__altered = false
    return list
  end

  return makeList(
    list._origin,
    list._capacity,
    list._level,
    list._root,
    list._tail,
    ownerID,
    list.__hash
  )
end

return ensureOwner
