local path = require('path')

local draw = {}

draw.SCALE = 8
draw.SIZE = 16
draw.SCALED_SIZE = draw.SIZE * draw.SCALE / 2

function draw.tiles(graphics, state)
  for row, tilesRow in ipairs(state.map.tiles) do
    for col, tileType in ipairs(tilesRow) do
      local image = (tileType == path.PATH_TYPE)
        and graphics.images.tilePath
        or graphics.images.tileWall

      love.graphics.draw(
        image,
        draw.SCALED_SIZE * (col - 1),
        draw.SCALED_SIZE * (row - 1),
        0,
        draw.SCALE,
        draw.SCALE
      )
    end
  end
end

return draw
