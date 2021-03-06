local path = require('lib.path')
local animation = require('lib.animation')
local color = require('lib.color')
local extract = require('scene.game.extract')

local draw = {}

local function drawAt(image, row, col, size, scaleX, scaleY, color)
  scaleX = scaleX or 1
  scaleY = scaleY or 1
  color = color or {255, 255, 255, 255}

  love.graphics.setColor(unpack(color))
  love.graphics.draw(
    image,
    extract.MARGIN_LEFT + size * extract.SIZE * extract.SCALE * (col - 1),
    extract.MARGIN_TOP + size * extract.SIZE * extract.SCALE * (row - 1),
    0,
    extract.SCALE * scaleX,
    extract.SCALE * scaleY,
    size * extract.SIZE / 2,
    size * extract.SIZE / 2
  )
end

function draw.tile(graphics, row, col, tileType)
  local image = (tileType == path.PATH_TYPE)
    and graphics.tilePath
    or graphics.tileWall

    drawAt(image, row, col, 1)
end

function draw.tiles(graphics, state)
  love.graphics.setColor(255, 255, 255, 255)

  for row, tilesRow in ipairs(state.map.tiles) do
    for col, tileType in ipairs(tilesRow) do
      if ((tileType == path.PATH_TYPE) or (tileType == path.WALL_TYPE)) then
        draw.tile(graphics, row, col, tileType)
      end
    end
  end
end

function draw.mob(graphics, mob)
  local screenState = extract.mobScreenState(mob)
  local scaleX = 1
  local images = {
    [extract.IDLE] = graphics[mob.type].front[1],
    [extract.FLAT] = graphics[mob.type].front[2],
    [extract.UP] = graphics[mob.type].front[3]
  }

  if screenState.posture == extract.POSTURE_BACK then
    images = {
      [extract.IDLE] = graphics[mob.type].back[1],
      [extract.FLAT] = graphics[mob.type].back[2],
      [extract.UP] = graphics[mob.type].back[3]
    }
  elseif screenState.posture == extract.POSTURE_LEFT or screenState.posture == extract.POSTURE_RIGHT then
    images = {
      [extract.IDLE] = graphics[mob.type].profile[1],
      [extract.FLAT] = graphics[mob.type].profile[2],
      [extract.UP] = graphics[mob.type].profile[3]
    }
    if screenState.posture == extract.POSTURE_LEFT then
      scaleX = -1
    end
  end

  local color = {255, 255, 255, 255}
  if mob.anim.cursor < 1 then
    if mob.anim.name == 'hurt' then
      local val = 100 + (100 * mob.anim.cursor)
      color = {val + 50, val, val, 255}
    elseif mob.anim.name == 'killed' then
      local alpha = 100 * (math.ceil(mob.anim.cursor * 10) % 2)
      color[#color] = alpha
    end
  end
  drawAt(images[screenState.bumpState], screenState.row, screenState.col, 1, scaleX, 1, color)

  -- mob life bar
  local remainingLife = mob.lives / mob.maxLives
  local barWidth = (extract.SIZE - 3) * extract.SCALE
  local barX = extract.MARGIN_LEFT + extract.SIZE * extract.SCALE * (screenState.col - 1)
  local barY = extract.MARGIN_TOP + extract.SIZE * extract.SCALE * (screenState.row - 1)
  barX = barX - barWidth / 2
  barY = barY + extract.SIZE * extract.SCALE / 2 + 4
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.rectangle('fill', barX, barY, barWidth, 4)
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.rectangle('fill', barX, barY, barWidth * remainingLife, 4)
end

function draw.mobs(graphics, state)
  love.graphics.setColor(255, 255, 255, 255)
  for __, mob in pairs(state.mobs) do
    local killedAnim = mob.anim.cursor < 1 and mob.anim.name == 'killed'
    if mob.lives > 0 or killedAnim then
      draw.mob(graphics, mob)
    end
  end
end

function draw.bullets(graphics, candle)
  for __, bullet in pairs(candle.bullets) do
    if not bullet.touched then

      local fromColor = color.BULLET_PARTICLE[candle.type][1]
      local toColor = color.BULLET_PARTICLE[candle.type][2]
      for i, particle in pairs(bullet.particles) do
        local color = {0, 0, 0}
        for c = 1, 3 do
          color[c] = animation.lerp(fromColor[c], toColor[c], i / extract.CANDLE_PARTICLES_COUNT)
        end

        -- color[#color + 1] = 150 - i * 10
        color[#color + 1] = 50 + i * 10
        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
          'fill',
          extract.MARGIN_LEFT + extract.SIZE * extract.SCALE * (particle.col - 1) + extract.SCALE,
          extract.MARGIN_TOP + extract.SIZE * extract.SCALE * (particle.row - 1) + extract.SCALE,
          8, 8
        )
      end

      love.graphics.setColor(unpack(toColor))
      love.graphics.rectangle(
        'fill',
        extract.MARGIN_LEFT + extract.SIZE * extract.SCALE * (bullet.tile.col - 1) + extract.SCALE,
        extract.MARGIN_TOP + extract.SIZE * extract.SCALE * (bullet.tile.row - 1) + extract.SCALE,
        8, 8
      )
    end
  end
end

function draw.candles(graphics, state)
  for __, candle in pairs(state.candles) do
    local images = graphics[candle.type]
    local image = images[1]

    if candle.burn.cursor > 0.7 then
      image = images[3]
    elseif candle.burn.cursor > 0.3 then
      image = images[2]
    end

    drawAt(image, candle.tile.row - 1, candle.tile.col, 1)
    draw.bullets(graphics, candle)
  end
end

function draw.pizza(graphics, state)
  love.graphics.setColor(255, 255, 255, 255)
  local pizza = state.pizza
  for _, slice in pairs(pizza.slices) do
    local image = graphics.pizza[slice]
    drawAt(image, pizza.tile.row - 0.5, pizza.tile.col - 0.5, 1)
  end
end

function draw.ui(graphics, state)
  love.graphics.setColor(227, 227, 227, 255)
  love.graphics.rectangle(
    'fill',
    love.graphics.getWidth() - (20 * extract.UI_SCALE),
    0,
    (20 * extract.UI_SCALE),
    love.graphics.getHeight()
  )

  for i, button in pairs(state.ui.towers) do
    local image = graphics.ui.button[1]
    if button.selected then
      image = graphics.ui.button[2]
    end
    local alpha = 255
    if not button.available then
      alpha = 100
    end
    love.graphics.setColor(227, 227, 227, alpha)
    love.graphics.draw(
      image,
      love.graphics.getWidth() - (18 * extract.UI_SCALE),
      (18 * extract.UI_SCALE) * (i - 1) + (2 * extract.UI_SCALE),
      0,
      extract.UI_SCALE,
      extract.UI_SCALE
    )
    love.graphics.draw(
      graphics[button.type][1],
      love.graphics.getWidth() - (14 * extract.UI_SCALE),
      (18 * extract.UI_SCALE) * (i - 1) + (2 * extract.UI_SCALE),
      0,
      extract.UI_SCALE,
      extract.UI_SCALE
    )

    love.graphics.setFont(graphics.fonts.munro.small_18)
    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.printf(
      tostring(button.price),
      love.graphics.getWidth() - (16 * extract.UI_SCALE),
      (18 * extract.UI_SCALE) * (i - 1) + (11 * extract.UI_SCALE),
      18 * extract.UI_SCALE,
      'left'
    )
  end

  local money = extract.moneyAvailable(state)
  love.graphics.setFont(graphics.fonts.munro.small_30)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.printf(
    tostring(money),
    love.graphics.getWidth() - (20 * extract.UI_SCALE),
    love.graphics.getHeight() - (10 * extract.UI_SCALE),
    20 * extract.UI_SCALE,
    'center'
  )
end

function draw.hover(graphics, state)
  local tower = extract.selectedTower(state.ui.towers)
  if tower == nil or not extract.isInMap(state.hover, state.map) then
    return state.hover
  end
  love.graphics.setColor(255, 0, 0, 255)

  if extract.canAddTower(state.hover, state.map, state.candles) then
    love.graphics.setColor(0, 255, 0, 255)
  end

  love.graphics.rectangle(
    'line',
    extract.MARGIN_LEFT + extract.SIZE * extract.SCALE * (state.hover.col - 1) - extract.SIZE * extract.SCALE / 2,
    extract.MARGIN_TOP + extract.SIZE * extract.SCALE * (state.hover.row - 1) - extract.SIZE * extract.SCALE / 2,
    extract.SIZE * extract.SCALE,
    extract.SIZE * extract.SCALE
  )
end

function draw.gameOver(graphics, state)
  if not state.gameOver then
    return
  end

  local backgroundColor = color.opacity(color.BLACK, state.gameOver.cursor * 3 / 4)
  if state.gameOver.success then
    local animatedColor = {}
    for i = 1, 4 do
      animatedColor[i] = animation.lerp(
        state.gameOver.background.fromColor[i],
        state.gameOver.background.toColor[i],
        state.gameOver.background.cursor
      )
    end
    backgroundColor = color.opacity(animatedColor, state.gameOver.cursor * 3 / 4)
  end
  local windowWidth, windowHeight = love.graphics.getDimensions()

  love.graphics.setColor(unpack(backgroundColor))
  love.graphics.rectangle('fill', 0, 0, love.graphics.getDimensions())

  if state.gameOver.cursor < 1 then
    return
  end

  love.graphics.setFont(graphics.fonts.silkscreen.bold_50)
  love.graphics.setColor(unpack(color.PIZZA_TOMATO_RED))
  if state.gameOver.success then
    love.graphics.printf('You did it!', 0, 150, windowWidth, 'center')
  else
    love.graphics.printf('Game Over', 0, 150, windowWidth, 'center')
  end

  love.graphics.setFont(graphics.fonts.silkscreen.normal_30)
  love.graphics.setColor(unpack(color.MOZZA_LIGHT_GRAY))
  love.graphics.printf('Click to go back\nto the main menu', 0, 300, windowWidth, 'center')
end

function draw.all(graphics, state)
  draw.tiles(graphics, state)
  draw.hover(graphics, state)
  draw.pizza(graphics, state)
  draw.mobs(graphics, state)
  draw.candles(graphics, state)
  draw.ui(graphics, state)
  draw.gameOver(graphics, state)
end

return draw
