local color = require('lib.color')
local extract = require('scene.mainmenu.extract')

local draw = {}

function draw.slice(graphics, slice)
  love.graphics.setColor(unpack(color.WHITE))
  love.graphics.draw(
    graphics.pizza_canvas,
    slice.x,
    slice.y,
    2 * math.pi * slice.turn.cursor,
    4,
    4,
    8,
    8
  )
end

function draw.all(graphics, state)
  local windowWidth, windowHeight = love.graphics.getDimensions()

  -- Background
  love.graphics.setColor(unpack(color.BULLET_PARTICLE.blueCandle[2]))
  love.graphics.rectangle('fill', 0, 0, windowWidth, windowHeight)

  love.graphics.setColor(unpack(color.WHITE))

  for __, slice in pairs(state.slices) do
    draw.slice(graphics, slice)
  end

  -- Title
  love.graphics.setFont(graphics.fonts.silkscreen.bold_50)
  love.graphics.setColor(unpack(color.MOZZA_LIGHT_GRAY))
  love.graphics.printf('Pizza Yolo', 0, 152, windowWidth, 'center')
  love.graphics.setColor(unpack(color.PIZZA_PEPPERONI_RED))
  love.graphics.printf('Pizza Yolo', 0, 150, windowWidth, 'center')

  -- Play message
  love.graphics.setFont(graphics.fonts.silkscreen.normal_30)
  love.graphics.setColor(unpack(color.MOZZA_LIGHT_GRAY))
  love.graphics.printf('Click to play', 0, 360, windowWidth, 'center')
end

return draw
