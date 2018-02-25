local clone

local function get(array, zidx)
  return array.tab[zidx + 1]
end

local function set(array, zidx, value)
  array.tab[zidx + 1] = value
end

local function size(array)
  return #array.tab
end

local function pop()
  return table.remove(array.tab, #array.tab)
end

local function newArray(tab)
  local array = {
    tab = tab or {}
  }

  array.clone = clone
  array.get = get
  array.pop = pop
  array.set = set
  array.size = size

  return array
end

clone = function (array)
  return newArray({unpack(array.tab)})
end


return newArray
