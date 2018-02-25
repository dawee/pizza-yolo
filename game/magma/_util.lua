local util = {}

local stringHashCache = {}

util.NOT_SET = {}
util.SIZE = 32
util.SHIFT = 5
util.MASK = util.SIZE - 1
util.STRING_HASH_CACHE_MIN_STRLEN = 16
util.STRING_HASH_CACHE_MAX_SIZE = 255
util.STRING_HASH_CACHE_SIZE = 0
util.CHANGE_LENGTH = {value = false}
util.DID_ALTER = {value = false}

function util.iteratorDone()
  return {value = nil, done = true}
end

function util.iteratorValue(k, v, iteratorResult)
  local value = {k, v}

  if iteratorResult then
    return value
  end

  return {value = value, done = false}
end


function util.newOwnerId()
  return {}
end

function util.is(valueA, valueB)
  return valueA == valueB
end

function util.makeRef(ref)
  ref.value = false
  return ref
end

function util.setRef(ref)
  if ref then
    ref.value = true
  end
end

function util.arrCopy(tab)
  return {unpack(tab)}
end

function util.setAt(array, idx, val, canEdit)
  local newArray = canEdit and array or util.arrCopy(array)

  newArray[idx] = val
  return newArray
end

function util.smi(i32)
  return bit.bor(bit.band(bit.rshift(i32, 1), 0x40000000), bit.band(i32, 0xbfffffff))
end

function util.hashString(string)
  local ii = 1
  local hashed = 0

  while ii <= string:len() do
    hashed = (31 * hashed + bit.bor(string.byte(string:sub(ii, ii)), 0))
    ii = ii + 1
  end

  return util.smi(hashed)
end

function util.cachedHashString(string)
  local hashed = stringHashCache[string]

  if hashed == nil then
    hashed = util.hashString(string)

    if util.STRING_HASH_CACHE_SIZE == util.STRING_HASH_CACHE_MAX_SIZE then
      util.STRING_HASH_CACHE_SIZE = 0
      stringHashCache = {}
    end

    util.STRING_HASH_CACHE_SIZE = util.STRING_HASH_CACHE_SIZE + 1
    stringHashCache[string] = hashed
  end

  return hashed
end

function util.hash(o)
  if (o == false) or (o == nil) then
    return 0
  end

  if o == true then
    return 1
  end

  if (type(o) == 'number') then
    local h = bit.bor(o, 0)

    if not (h == o) then
      h = h ^ (o * 0xffffffff)
    end

    while (o > 0xffffffff) do
      o = o / 0xffffffff
      h = h ^ o
    end

    return smi(h)
  end

  if (type(o) == 'string') then
    if o:len() > util.STRING_HASH_CACHE_MIN_STRLEN then
      return util.cachedHashString(o)
    else
      return util.hashString(o)
    end
  end

  if type(o.hashCode) == 'function' then
    -- Drop any high bits from accidentally long hash codes.
    return smi(o:hashCode())
  end

  error('Value type ' .. type(o) .. ' cannot be hashed.')
end

return util
