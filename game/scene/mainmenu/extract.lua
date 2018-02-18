local extract = {}

function extract.isPlayButtonHovered(state)
  local windowWidth, windowHeight = love.graphics.getDimensions()

  return (state.hover.y > 300)
    and (state.hover.y < 330)
    and (state.hover.x > 280)
    and (state.hover.x < (windowWidth - 280))
end

return extract
