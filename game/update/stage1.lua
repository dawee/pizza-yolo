local extract = require('extract')
local path = require('path')
local shoot = require('shoot')
local mapUpdate = require('update.mapupdate')
local merge = require('update.merge')

local update = {}

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
  if mob.lives == 0 then
    return mob
  end

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
  local buttons = state.ui.towers
  if love.mouse.isDown(1) then
    local towers = {unpack(buttons)}
    for i, button in pairs(buttons) do
      towers[i].selected = false
      local buttonPositionX = love.graphics.getWidth() - (18 * extract.UI_SCALE)
      local buttonPositionY = (18 * extract.UI_SCALE) * (i - 1) + (2 * extract.UI_SCALE)

      local mouseX, mouseY = love.mouse.getPosition()
      if mouseX > buttonPositionX and mouseX < buttonPositionX + (16 * extract.UI_SCALE) then
        if mouseY > buttonPositionY and mouseY < buttonPositionY + (16 * extract.UI_SCALE) then
          towers[i].selected = true
        end
      end
    end
    return state.ui
  end
  return merge(state.ui, {
    towers = towers
  })
end

function update.hover(state)
  local mouseX, mouseY = love.mouse.getPosition()
  local tileSize =  extract.SIZE * extract.SCALE
  mouseX = mouseX - extract.MARGIN_LEFT + tileSize / 2
  mouseY = mouseY - extract.MARGIN_TOP + tileSize / 2
  local col = math.ceil(mouseX / tileSize)
  local row = math.ceil(mouseY / tileSize)

  local hover = {
    row = row,
    col = col
  }

  if hover.row == state.hover.row and hover.col == state.hover.col then
    return state.hover
  end
  return merge(state.hover, hover)
end

function update.all(state, dt)
  return merge(state, {
    candles = mapUpdate(update.candle, state.candles, state, dt),
    mobs = mapUpdate(update.mob, state.mobs, state, dt),
    pizza = update.pizza(state),
    ui = update.ui(state),
    hover = update.hover(state)
  })
end

return update
