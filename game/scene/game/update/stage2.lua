local extract = require('scene.game.extract')
local path = require('lib.path')
local mapUpdate = require('lib.mapupdate')
local merge = require('lib.merge')
local cycle = require('lib.cycle')
local color = require('lib.color')

local update = {}

function update.mob(mob, state, dt)
  if extract.isGameStopped(state) then
    return mob
  end

  local anim = mob.anim
  if anim.cursor < 1 then
    anim = merge(mob.anim, {
      cursor = math.min(1, anim.cursor + dt / anim.duration)
    })
  end

  if mob.lives == 0 then
    return merge(mob, {anim = anim})
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
    ate = ate,
    anim = anim
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

  local particles = {unpack(bullet.particles)}
  particles[#particles + 1] = bullet.tile
  if #particles > extract.CANDLE_PARTICLES_COUNT then
    table.remove(particles, 1)
  end

  return merge(bullet, {
    touched = (oppositeDistance < 0.05) and (adjacentDistance < 0.05),
    tile = {
      row = bullet.tile.row + moveDistance * math.sin(shootAngle) * rowDirection,
      col = bullet.tile.col + moveDistance * math.cos(shootAngle) * colDirection
    },
    particles = particles
  })
end

function update.bullets(bullets, candle, state, dt)
  if extract.isGameStopped(state) then
    return bullets
  end

  local newBullets = bullets

  if cycle.isNew(candle.shoot) then
    local mobsIds = extract.mobsNearTower(candle, state)

    if #mobsIds > 0 then
      newBullets = {unpack(bullets)}
      newBullets[#newBullets + 1] = {
        touched = false,
        tile = {row = candle.tile.row - 1, col = candle.tile.col},
        mobId = mobsIds[1],
        particles = {}
      }
    end
  end

  return mapUpdate(update.oneBullet, newBullets, candle, state, dt)
end

function update.candle(candle, state, dt)
  return merge(candle, {
    burn = cycle.run(candle.burn, dt),
    shoot = cycle.run(candle.shoot, dt),
    bullets = update.bullets(candle.bullets, candle, state, dt)
  })
end

function update.candles(updateCandle, stateCandles, state, dt)
  if extract.isGameStopped(state) then
    return stateCandles
  end

  local candles = mapUpdate(updateCandle, stateCandles, state, dt)
  local selectedTower = extract.selectedTower(state.ui.towers)
  if extract.clicked(state) and not (selectedTower == nil) then
    if extract.canAddTower(state.hover, state.map, candles) then
      candles[#candles + 1] = merge(selectedTower, {
          bullets = {},
          tile = {row = state.hover.row, col = state.hover.col}
        }
      )
    end
  end
  return candles
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
  while (#slices > 0) and (#slices > remainingSlices) do
    math.randomseed(os.time())
    table.remove(slices, math.random(#slices))
  end

  return merge(state.pizza, {
    slices = slices
  })
end

function update.ui(state)
  if extract.isGameStopped(state) then
    return state.ui
  end

  local buttons = state.ui.towers
  local money = extract.moneyAvailable(state)
  local towers = {unpack(buttons)}
  for i, button in pairs(buttons) do
    local available = money >= button.price
    towers[i].available = available

    if available and extract.clicked(state) then
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
  end
  return merge(state.ui, {
    towers = towers
  })
end

function update.hover(state)
  if extract.isGameStopped(state) then
    return state.hover
  end

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

function update.gameOver(gameOver, state, dt)
  local completed = extract.isLevelCompleted(state)
  if not gameOver then
    return (extract.isGameOver(state) or completed)
      and {
        duration = 1,
        cursor = 0,
        success = completed,
        background = {duration = 1, cursor = 0, fromColor = color.BLACK, toColor = color.BLACK}
      }
      or nil
  end

  local cursor = gameOver.cursor + dt / gameOver.duration

  if (cursor > 1) then
    cursor = 1
  end

  local background = gameOver.background
  if gameOver.success then
    local bgCursor = gameOver.background.cursor + dt / gameOver.background.duration
    local fromColor = gameOver.background.fromColor
    local toColor = gameOver.background.toColor
    if bgCursor > 1 then
      local possibleColors = {}
      fromColor = toColor
      for _, c in pairs(color.SUCCESS_BACKGROUND) do
        local same = fromColor[1] == c[1] and fromColor[2] == c[2] and fromColor[3] == c[3]
        if not same then
          possibleColors[#possibleColors + 1] = c
        end
      end
      bgCursor = 0
      toColor = possibleColors[math.random(#possibleColors)]
    end
    background = merge(gameOver.background, {
      cursor = bgCursor,
      fromColor = fromColor,
      toColor = toColor
    })
  end

  return merge(gameOver, {cursor = cursor, background = background})
end

function update.all(state, dt)
  return merge(state, {
    candles = update.candles(update.candle, state.candles, state, dt),
    gameOver = update.gameOver(state.gameOver, state, dt),
    mobs = mapUpdate(update.mob, state.mobs, state, dt),
    pizza = update.pizza(state),
    ui = update.ui(state),
    hover = update.hover(state)
  })
end

return update
