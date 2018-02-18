local cycle = require('lib.cycle')
local merge = require('lib.merge')

local update = {}

function update.schedule(schedule, state, dt)
  return merge(schedule, {
    tick = cycle.run(schedule.tick, dt)
  })
end

function update.mobs(mobs, state, dt)
  return mobs
end

function update.all(state, dt)
  return merge(state, {
    schedule = update.schedule(state.schedule, state, dt),
    mobs = update.mobs(state.mobs, state, dt)
  })
end

return update
