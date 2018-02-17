local path = require('path')

local draw = {}

draw.SCALE = 8
draw.SIZE = 16
draw.MARGIN_TOP = 50
draw.MARGIN_LEFT = 50

local function drawAt(image, row, col, size)
  love.graphics.draw(
    image,
    draw.MARGIN_LEFT + size * draw.SIZE * draw.SCALE * (col - 1) / 2,
    draw.MARGIN_TOP + size * draw.SIZE * draw.SCALE * (row - 1) / 2,
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
    drawAt(
      graphics.mozza.front[1],
      mob.previousTile.row + (mob.tile.row - mob.previousTile.row) * mob.cursor,
      mob.previousTile.col + (mob.tile.col - mob.previousTile.col) * mob.cursor,
      1
    )
  end
end

function draw.all(graphics, state)
  draw.tiles(graphics, state)
  draw.mobs(graphics, state)
end

return draw
