local each = require('magma.each')
local get = require('magma.get')
local draw = require('draw')

local function createDrawMob(images)
  local image = get('mob', images)

  return function (mob)
    local row = get('position.row', mob)
    local col = get('position.col', mob)

    return draw(image, row, col)
  end
end

local function drawAllMobs(images, mobs)
  local drawMob = createDrawMob(images)

  return each(drawMob, mobs)
end

return drawAllMobs
