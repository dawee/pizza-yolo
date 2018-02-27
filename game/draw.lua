local SCALE = 8
local SIZE = 8
local SPAWN_ROWS = 6
local MARGIN_TOP = (SCALE * SIZE / 2) - (SPAWN_ROWS * SIZE * SCALE)
local MARGIN_LEFT = SCALE * SIZE / 2

local function draw(image, row, col, size, scaleX, scaleY, color)
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

return draw
