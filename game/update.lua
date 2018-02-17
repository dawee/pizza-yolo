local path = require('path')

local update = {}

local function mapUpdate(updater, iteratee, state, dt)
  local updated = {}

  for __, item in pairs(iteratee) do
    updated[#updated + 1] = updater(item, state, dt)
  end

  return updated
end

local function merge(defaults, values)
  local merged = {}

  for key, value in pairs(defaults) do
    merged[key] = value
  end

  for key, value in pairs(values) do
    merged[key] = value
  end

  return merged
end

function update.mob(mob, state, dt)
  local cursor = mob.cursor + mob.velocity * dt
  local previousTile = mob.previousTile
  local nextTile = mob.tile
  local seenTiles = mob.seenTiles

  if cursor >= 1 then
    seenTiles = {unpack(seenTiles)}
    seenTiles[#seenTiles + 1] = mob.tile
    nextTile = path.findNextTile(mob, state.map)
    previousTile = mob.tile
    cursor = 0
  end

  return merge(mob, {
    previousTile = previousTile,
    tile = nextTile,
    cursor = cursor,
    seenTiles = seenTiles
  })
end


function update.all(state, dt)
  return merge(state, {
    mobs = mapUpdate(update.mob, state.mobs, state, dt)
  })
end

return update
