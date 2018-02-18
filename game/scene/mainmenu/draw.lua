local color = require('lib.color')
local extract = require('scene.mainmenu.extract')

local draw = {}

function draw.playButton(graphics, state)
  local windowWidth, windowHeight = love.graphics.getDimensions()
  local buttonColor = extract.isPlayButtonHovered(state)
    and color.TILE_LIGHT_BLUE
    or color.TILE_DARK_BLUE

  love.graphics.setFont(graphics.fonts.silkscreen.normal_30)
  love.graphics.setColor(unpack(buttonColor))
  love.graphics.printf('Play', 0, 300, windowWidth, 'center')
end

function draw.all(graphics, state)
  local windowWidth, windowHeight = love.graphics.getDimensions()

  -- Background
  love.graphics.setColor(unpack(color.MOZZA_DARK_GRAY))
  love.graphics.rectangle('fill', 0, 0, windowWidth, windowHeight)

  -- Title
  love.graphics.setFont(graphics.fonts.silkscreen.bold_50)
  love.graphics.setColor(unpack(color.PIZZA_PEPPERONI_RED))
  love.graphics.printf('Pizza Yolo', 0, 150, windowWidth, 'center')

  draw.playButton(graphics, state)
end

return draw
