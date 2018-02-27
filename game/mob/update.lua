local get = require('magma.get')
local set = require('magma.set')
local pipe = require('magma.pipe')
local identity = require('magma.identity')
local types = require('action.type')

local function moveMob(action)
  local id = get('mobId', action)
  local row = get('row', action)
  local col = get('col', action)

  return pipe(
    set({'mobs', id, 'position', 'row'}, row),
    set({'mobs', id, 'position', 'col'}, col)
  )
end

local UPDATE = {
  [types.MOB_MOVE] = moveMob
}

local function updateMobs(action)
  local actionType = get('type', action)
  local update = UPDATE[actionType]

  return update and update(action) or identity
end

return updateMobs
