local animation = {}

local function easeOutSine(start, stop, cursor)
  return (stop - start) * math.sin(cursor * (math.pi / 2)) + start;
end

function animation.bump(previousTile, nextTile, cursor)
  local prepareDuration = 0.4

  if cursor < prepareDuration then
    return previousTile.row, previousTile.col
  else
    local bumpCursor = (1 / (prepareDuration + 1)) * cursor + prepareDuration / (prepareDuration + 1)
    local newRow = easeOutSine(previousTile.row, nextTile.row, cursor - prepareDuration)
    local newCol = easeOutSine(previousTile.col, nextTile.col, cursor - prepareDuration)

    return newRow, newCol
  end
end

return animation
