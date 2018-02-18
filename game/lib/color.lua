local color = {}

color.PIZZA_CHEEZE_YELLOW = {248, 227, 113, 255}
color.PIZZA_TOMATO_RED = {227, 64, 64, 255}
color.PIZZA_PEPPERONI_RED = {172, 50, 50, 255}
color.MOZZA_LIGHT_GRAY = {227, 227, 227, 255}
color.MOZZA_DARK_GRAY = {132, 126, 135, 255}
color.TILE_LIGHT_BLUE = {203, 219, 252, 255}
color.TILE_DARK_BLUE = {140, 160, 200, 255}
color.BLACK = {0, 0, 0, 255}
color.WHITE = {255, 255, 255, 255}

function color.opacity(inputColor, opacity)
  local outputColor = {unpack(inputColor)}

  outputColor[4] = opacity * outputColor[4]

  return outputColor
end

return color