local list = require('magma.list')
local get = require('magma.get')
local dict = require('magma.dict')
local merge = require('magma.merge')
local pipe = require('magma.pipe')
local reduce = require('magma.reduce')
local push = require('magma.push')
local types = require('action.type')

local function moveMob(state, dt)
  return function (actions, mob)
    local id = get('id', mob)
    local row = get('position.row', mob)
    local col = get('position.col', mob)
    local action = dict({
      type = types.MOB_MOVE,
      mobId = id,
      row = row + dt,
      col = col
    })

    return push(action, actions)
  end
end

local function moveMobs(state, dt)
  local mobs = get('mobs', state)
  local moveOne = moveMob(state, dt)

  return function (actions)
    return reduce(moveOne, actions, mobs)
  end
end

local function createActions(state, dt)
  local actions = list()
  local feed = pipe(
    moveMobs(state, dt)
  )

  return feed(actions)
end

return createActions
