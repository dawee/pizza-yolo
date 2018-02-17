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

local function runCycle(animation, dt)
  local cursor = animation.cursor + animation.velocity * dt

  if cursor >= 1 then
    cursor = 0
  end

  return merge(animation, {cursor = cursor})
end

function update.mob(mob, state, dt)
  local cursor = mob.cursor + mob.velocity * dt
  local previousTile = mob.previousTile
  local nextTile = mob.tile
  local seenTiles = mob.seenTiles
  local ate = mob.ate

  if cursor >= 1 then
    seenTiles = {unpack(seenTiles)}
    seenTiles[#seenTiles + 1] = mob.tile
    nextTile = path.findNextTile(mob, state.map)
    previousTile = mob.tile
    cursor = 0
  end

  if previousTile.row == state.pizza.tile.row and previousTile.col == state.pizza.tile.col then
    ate = true
  end

  return merge(mob, {
    previousTile = previousTile,
    tile = nextTile,
    cursor = cursor,
    seenTiles = seenTiles,
    ate = ate
  })
end

function update.candle(candle, state, dt)
  return merge(candle, {
    burn = runCycle(candle.burn, dt)
  })
end

function update.pizza(state)
  local eatenSlices = 0
  for _, mob in pairs(state.mobs) do
    if mob.ate then
      eatenSlices = eatenSlices + 1
    end
  end

  local remainingSlices = 8 - eatenSlices

  if #state.pizza.slices == remainingSlices then
    return state.pizza
  end

  local slices = {unpack(state.pizza.slices)}
  while #slices > remainingSlices do
    table.remove(slices, math.random(#slices))
  end

  return merge(state.pizza, {
    slices = slices
  })
end

function update.all(state, dt)
  return merge(state, {
    candles = mapUpdate(update.candle, state.candles, state, dt),
    mobs = mapUpdate(update.mob, state.mobs, state, dt),
    pizza = update.pizza(state)
  })
end

return update
