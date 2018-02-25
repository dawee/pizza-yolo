local util = require('magma._util')
local ensureOwner = require('magma.list.owner')
local setListBounds = require('magma.list.bounds')
local update = require('magma.list.update')
local newListIterator = require('magma.list.iterator')

local function clear(list)
  local emptyList = require('magma.list.empty')

  if list.size == 0 then
    return list
  end

  if list.__ownerID then
    list._capacity = 0
    list._origin = 0
    list.size = 0
    list._level = util.SHIFT
    list._tail = nil
    list._root = nil
    list.__hash = nil
    list.__altered = true
    return list
  end

  return emptyList()
end

local function wasAltered(list)
  return list.__altered
end

local function asMutable(list)
  return list.__ownerID and list or list:ensureOwner(util.newOwnerId())
end

local function withMutations(list, fn)
  local mutable = list:asMutable()

  fn(mutable)
  return mutable:wasAltered() and mutable:ensureOwner(list.__ownerID) or list
end

local function push(list, ...)
  local values = {...}
  local oldSize = list.size

  local function mutate(newList)
    setListBounds(newList, 0, oldSize + #values);

    for ii = 1, #values do
      newList:update(oldSize + ii - 1, values[ii])
    end
  end

  return list:withMutations(mutate)
end

local function makeList(origin, capacity, level, root, tail, ownerID, hash)
  local list = {
    size = capacity - origin,
    _origin = origin,
    _capacity = capacity,
    _level = level,
    _root = root,
    _tail = tail,
    __ownerID = ownerID,
    __hash = hash,
    __altered = false,
    __type = 'list'
  }

  list.asMutable = asMutable
  list.clear = clear
  list.ensureOwner = ensureOwner
  list.iterator = newListIterator
  list.push = push
  list.update = update
  list.wasAltered = wasAltered
  list.withMutations = withMutations

  return list
end

return makeList
