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
color.BULLET_PARTICLE = {
  candle = {{172, 50, 50}, {248, 227, 113}},
  greenCandle = {{55, 148, 110}, {153, 229, 80}},
  blueCandle = {{91, 110, 225}, {95, 205, 228}},
  purpleCandle = {{118, 66, 138}, {215, 123, 186}}
}
color.SUCCESS_BACKGROUND = {
  {172, 50, 50, 255},
  {248, 227, 113, 255},
  {91, 110, 225, 255},
  {95, 205, 228, 255},
  {118, 66, 138, 255},
  {215, 123, 186, 255}
}
color.POUET = 'ohai'

function color.opacity(inputColor, opacity)
  local outputColor = {unpack(inputColor)}

  outputColor[4] = opacity * outputColor[4]

  return outputColor
end

return color
