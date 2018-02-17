local path = require('path')

local draw = {}

draw.SCALE = 8
draw.SIZE = 16

local function drawAt(image, row, col, size)
  love.graphics.draw(
    image,
    size * draw.SIZE * draw.SCALE * (col - 1) / 2,
    size * draw.SIZE * draw.SCALE * (row - 1) / 2,
    0,
    draw.SCALE,
    draw.SCALE
  )
end

function draw.tiles(graphics, state)
  for row, tilesRow in ipairs(state.map.tiles) do
    for col, tileType in ipairs(tilesRow) do
      local image = (tileType == path.PATH_TYPE)
        and graphics.images.tilePath
        or graphics.images.tileWall

        drawAt(image, row, col, 1)
    end
  end
end

return draw
