local cycle = require('lib.cycle')
local merge = require('lib.merge')
local uuid = require('lib.uuid')

local update = {}

function update.schedule(schedule, state, dt)
  return merge(schedule, {
    tick = cycle.run(schedule.tick, dt)
  })
end

function update.mobs(mobs, state, dt)
  local series = state.schedule.series[state.schedule.tick.idx]

  if (not cycle.isNew(state.schedule.tick)) or (not series) then
    return mobs
  end

  local newMobs = {unpack(mobs)}

  for index, template in ipairs(series) do
    newMobs[#newMobs + 1] = {
      id = uuid(),
      lives = template.lives,
      maxLives = template.lives,
      velocity = template.velocity,
      previousTile = {row = 7 - index, col = 3},
      tile = {row = 8 - index, col = 3},
      cursor = 0,
      seenTiles = {},
      ate = false
    }
  end

  return newMobs
end

function update.all(state, dt)
  return merge(state, {
    schedule = update.schedule(state.schedule, state, dt),
    mobs = update.mobs(state.mobs, state, dt)
  })
end

return update
