local each = require('magma.each')
local get = require('magma.get')
local draw = require('draw')

local IMAGE_NAMES = {
  ['_'] = 'path',
  ['W'] = 'wall',
}

local function drawTile(images, row)
  return function (code, col)
    local imageName = IMAGE_NAMES[code]
    local image = imageName and get({'tile', imageName}, images)

    return image and draw(image, row, col)
  end
end

local function drawTileRow(images)
  return function (rowTiles, row)
    return each(drawTile(images, row), rowTiles)
  end
end

local function drawAllTiles(images, tiles)
  return each(drawTileRow(images), tiles)
end

return drawAllTiles
