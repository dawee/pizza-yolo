local animation = require('animation')

local extract = {}

extract.SCALE = 8
extract.SIZE = 8
extract.MARGIN_TOP = 0
extract.MARGIN_LEFT = 0
extract.UI_SCALE = 4
extract.UP = 'up'
extract.FLAT = 'flat'
extract.IDLE = 'idle'
extract.POSTURE_FRONT = 'posture_front'
extract.POSTURE_BACK = 'posture_back'
extract.POSTURE_LEFT = 'posture_left'
extract.POSTURE_RIGHT = 'posture_right'

function extract.mobScreenState(mob)
  local startCursor = 0.4
  local endCursor = 0.7
  local bumpState = extract.IDLE
  local posture = extract.POSTURE_FRONT

  if mob.previousTile.row > mob.tile.row then
    posture = extract.POSTURE_BACK
  elseif mob.previousTile.col < mob.tile.col then
    posture = extract.POSTURE_RIGHT
  elseif mob.previousTile.col > mob.tile.col then
    posture = extract.POSTURE_LEFT
  end

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
      bumpState = bumpState,
      posture = posture
    }
  elseif mob.cursor > endCursor then
    return {
      row = mob.tile.row,
      col = mob.tile.col,
      bumpState = bumpState,
      posture = posture
    }
  end

  local bumpCursor = (mob.cursor - startCursor) / (endCursor - startCursor)

  return {
    row = animation.easeOutSine(mob.previousTile.row, mob.tile.row, bumpCursor),
    col = animation.easeOutSine(mob.previousTile.col, mob.tile.col, bumpCursor),
    bumpState = bumpState,
    posture = posture
  }
end

function extract.towers(buttons)
  local towers = {unpack(buttons)}
  for i, button in pairs(buttons) do
    towers[i].selected = false
    local buttonPositionX = love.graphics.getWidth() - (18 * extract.UI_SCALE)
    local buttonPositionY = (18 * extract.UI_SCALE) * (i - 1) + (2 * extract.UI_SCALE)

    local mouseX, mouseY = love.mouse.getPosition()
    if mouseX > buttonPositionX and mouseX < buttonPositionX + (16 * extract.UI_SCALE) then
      if mouseY > buttonPositionY and mouseY < buttonPositionY + (16 * extract.UI_SCALE) then
        towers[i].selected = true
      end
    end
  end
  return towers
end

return extract
