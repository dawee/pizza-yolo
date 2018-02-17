local animation = {}

local function easeOutSine(start, stop, cursor)
  return (stop - start) * math.sin(cursor * (math.pi / 2)) + start;
end

function animation.bump(previousTile, nextTile, cursor)
  local startCursor = 0.4
  local endCursor = 0.7

  if cursor < startCursor then
    return previousTile.row, previousTile.col
  elseif cursor > endCursor then
    return nextTile.row, nextTile.col
  end

  local bumpCursor = (cursor - startCursor) / (endCursor - startCursor)
  local newRow = easeOutSine(previousTile.row, nextTile.row, bumpCursor)
  local newCol = easeOutSine(previousTile.col, nextTile.col, bumpCursor)

  return newRow, newCol
end

return animation
