local path = require('path')
local animation = require('animation')

local draw = {}

draw.SCALE = 8
draw.SIZE = 8
draw.MARGIN_TOP = 50
draw.MARGIN_LEFT = 50

local function drawAt(image, row, col, size)
  love.graphics.draw(
    image,
    draw.MARGIN_LEFT + size * draw.SIZE * draw.SCALE * (col - 1),
    draw.MARGIN_TOP + size * draw.SIZE * draw.SCALE * (row - 1),
    0,
    draw.SCALE,
    draw.SCALE
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
    local row, col = animation.bump(mob.previousTile, mob.tile, mob.cursor)
    local image = graphics.mozza.front[1]

    if mob.cursor > 0.2 and mob.cursor < 0.4 then
      image = graphics.mozza.front[2]
    elseif mob.cursor >= 0.6 then
      image = graphics.mozza.front[3]
    end

    drawAt(image, row, col, 1)
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
  end
end

function draw.all(graphics, state)
  draw.tiles(graphics, state)
  draw.candles(graphics, state)
  draw.mobs(graphics, state)
end

return draw
