local each = require('magma.each')
local get = require('magma.get')

local IMAGE_NAMES = {
  ['_'] = 'path',
  ['W'] = 'wall',
}

local SCALE = 8
local SIZE = 8
local SPAWN_ROWS = 6
local MARGIN_TOP = (SCALE * SIZE / 2) - (SPAWN_ROWS * SIZE * SCALE)
local MARGIN_LEFT = SCALE * SIZE / 2

local function drawAt(image, row, col, size, scaleX, scaleY, color)
  size = size or 1
  scaleX = scaleX or 1
  scaleY = scaleY or 1
  color = color or {255, 255, 255, 255}

  love.graphics.setColor(unpack(color))
  love.graphics.draw(
    image,
    MARGIN_LEFT + size * SIZE * SCALE * col,
    MARGIN_TOP + size * SIZE * SCALE * row,
    0,
    SCALE * scaleX,
    SCALE * scaleY,
    size * SIZE / 2,
    size * SIZE / 2
  )
end

local function createDrawTile(graphics, row)
  return function (code, col)
    local imageName = IMAGE_NAMES[code]
    local image = imageName and get({'tile', imageName}, graphics)

    return image and drawAt(image, row, col)
  end
end

local function createDrawTileRow(graphics)
  return function (rowTiles, row)
    local drawTile = createDrawTile(graphics, row)

    return each(drawTile, rowTiles)
  end
end

local function drawAllTiles(state)
  local graphics = get('graphics', state)
  local tiles = get('tiles', state)
  local drawTileRow = createDrawTileRow(graphics)

  return each(drawTileRow, tiles)
end

return  {
  drawAll = drawAllTiles
}
