local path = require('path')
local extract = require('extract')

local draw = {}

draw.SCALE = 8
draw.SIZE = 8
draw.MARGIN_TOP = 50
draw.MARGIN_LEFT = 50

local function drawAt(image, row, col, size, scaleX, scaleY)
  scaleX = scaleX or 1
  scaleY = scaleY or 1
  love.graphics.draw(
    image,
    draw.MARGIN_LEFT + size * draw.SIZE * draw.SCALE * (col - 1),
    draw.MARGIN_TOP + size * draw.SIZE * draw.SCALE * (row - 1),
    0,
    draw.SCALE * scaleX,
    draw.SCALE * scaleY,
    size * draw.SIZE / 2,
    size * draw.SIZE / 2
  )
end

function draw.tiles(graphics, state)
  for row, tilesRow in ipairs(state.map.tiles) do
    for col, tileType in ipairs(tilesRow) do
      local image = (tileType == path.PATH_TYPE)
        and graphics.tilePath
        or graphics.tileWall

        drawAt(image, row, col, 1)
    end
  end
end

function draw.mobs(graphics, state)
  for __, mob in pairs(state.mobs) do
    local screenState = extract.mobScreenState(mob)
    local scaleX = 1
    local images = {
      [extract.IDLE] = graphics.mozza.front[1],
      [extract.FLAT] = graphics.mozza.front[2],
      [extract.UP] = graphics.mozza.front[3]
    }

    if screenState.posture == extract.POSTURE_BACK then
      images = {
        [extract.IDLE] = graphics.mozza.back[1],
        [extract.FLAT] = graphics.mozza.back[2],
        [extract.UP] = graphics.mozza.back[3]
      }
    elseif screenState.posture == extract.POSTURE_LEFT or screenState.posture == extract.POSTURE_RIGHT then
      images = {
        [extract.IDLE] = graphics.mozza.profile[1],
        [extract.FLAT] = graphics.mozza.profile[2],
        [extract.UP] = graphics.mozza.profile[3]
      }
      if screenState.posture == extract.POSTURE_LEFT then
        scaleX = -1
      end
    end

    drawAt(images[screenState.bumpState], screenState.row, screenState.col, 1, scaleX)
  end
end

function draw.bullets(graphics, bullets)
  for __, bullet in pairs(bullets) do
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle(
      'fill',
      draw.MARGIN_LEFT + draw.SIZE * draw.SCALE * (bullet.tile.col - 1),
      draw.MARGIN_TOP + draw.SIZE * draw.SCALE * (bullet.tile.row - 1),
      2, 2
    )
    love.graphics.setColor(255, 255, 255, 255)
  end
end

function draw.candles(graphics, state)
  for __, candle in pairs(state.candles) do
    local image = graphics.candle[1]

    if candle.burn.cursor > 0.7 then
      image = graphics.candle[3]
    elseif candle.burn.cursor > 0.3 then
      image = graphics.candle[2]
    end

    drawAt(image, candle.tile.row, candle.tile.col, 1)
    draw.bullets(graphics, candle.bullets)
  end
end

function draw.all(graphics, state)
  draw.tiles(graphics, state)
  draw.mobs(graphics, state)
  draw.candles(graphics, state)
end

return draw
