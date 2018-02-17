local animation = require('animation')

local extract = {}

extract.UP = 'up'
extract.FLAT = 'flat'
extract.IDLE = 'idle'

function extract.mobScreenState(mob)
  local startCursor = 0.4
  local endCursor = 0.7
  local bumpState = extract.IDLE

  if mob.cursor > 0.2 and mob.cursor < 0.4 then
    bumpState = extract.FLAT
  elseif mob.cursor >= 0.4 and mob.cursor < 0.7 then
    bumpState = extract.UP
  elseif mob.cursor >= 0.7 and mob.cursor < 0.9 then
    bumpState = extract.FLAT
  end

  if mob.cursor < startCursor then
    return {
      row = mob.previousTile.row,
      col = mob.previousTile.col,
      bumpState = bumpState
    }
  elseif mob.cursor > endCursor then
    return {
      row = mob.tile.row,
      col = mob.tile.col,
      bumpState = bumpState
    }
  end

  local bumpCursor = (mob.cursor - startCursor) / (endCursor - startCursor)

  return {
    row = animation.easeOutSine(mob.previousTile.row, mob.tile.row, bumpCursor),
    col = animation.easeOutSine(mob.previousTile.col, mob.tile.col, bumpCursor),
    bumpState = bumpState
  }
end

return extract
