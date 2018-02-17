local extract = require('extract')
local path = require('path')
local shoot = require('shoot')

local update = {}

local function mapUpdate(updater, iteratee, ...)
  local args = {...}
  local updated = {}

  for __, item in pairs(iteratee) do
    updated[#updated + 1] = updater(item, unpack(args))
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

local function isNewCycle(animation)
  return animation.cursor == 0
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

function update.oneBullet(bullet, candle, state, dt)
  if bullet.touched then
    return bullet
  end

  local targetMob = nil

  for __, mob in pairs(state.mobs) do
    if mob.id == bullet.mobId then
      targetMob = mob
      break
    end
  end

  local mobScreenState = extract.mobScreenState(targetMob)

  local oppositeDistance = math.abs(mobScreenState.row - bullet.tile.row)
  local adjacentDistance = math.abs(mobScreenState.col - bullet.tile.col)
  local shootAngle = math.atan(oppositeDistance / adjacentDistance)
  local moveDistance = candle.bulletVelocity * dt
  local rowDirection = 1
  local colDirection = 1

  if mobScreenState.row < bullet.tile.row then
    rowDirection = -1
  end

  if mobScreenState.col < bullet.tile.col then
    colDirection = -1
  end

  return merge(bullet, {
    touched = (oppositeDistance < 0.05) and (adjacentDistance < 0.05),
    tile = {
      row = bullet.tile.row + moveDistance * math.sin(shootAngle) * rowDirection,
      col = bullet.tile.col + moveDistance * math.cos(shootAngle) * colDirection
    }
  })
end

function update.bullets(bullets, candle, state, dt)
  local newBullets = bullets

  if isNewCycle(candle.shoot) then
    local mobsIds = shoot.findMobsNearTower(candle, state)

    if #mobsIds > 0 then
      newBullets = {unpack(bullets)}
      newBullets[#newBullets + 1] = {
        touched = false,
        tile = {row = candle.tile.row, col = candle.tile.col},
        mobId = mobsIds[1]
      }
    end
  end

  return mapUpdate(update.oneBullet, newBullets, candle, state, dt)
end

function update.candle(candle, state, dt)
  return merge(candle, {
    burn = runCycle(candle.burn, dt),
    shoot = runCycle(candle.shoot, dt),
    bullets = update.bullets(candle.bullets, candle, state, dt)
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

function update.ui(state)
  local towers = state.ui.towers
  if love.mouse.isDown(1) then
    towers = extract.towers(towers)
  end
  return merge(state.ui, {
    towers = towers
  })
end

function update.all(state, dt)
  return merge(state, {
    candles = mapUpdate(update.candle, state.candles, state, dt),
    mobs = mapUpdate(update.mob, state.mobs, state, dt),
    pizza = update.pizza(state),
    ui = update.ui(state)
  })
end

return update
