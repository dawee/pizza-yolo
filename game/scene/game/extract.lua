local animation = require('lib.animation')
local path = require('lib.path')

local extract = {}

extract.SCALE = 8
extract.SIZE = 8
extract.SPAWN_ROWS = 6
extract.MARGIN_TOP = (extract.SCALE * extract.SIZE / 2) - (extract.SPAWN_ROWS * extract.SIZE * extract.SCALE)
extract.MARGIN_LEFT = extract.SCALE * extract.SIZE / 2
extract.UI_SCALE = 4
extract.UP = 'up'
extract.FLAT = 'flat'
extract.IDLE = 'idle'
extract.POSTURE_FRONT = 'posture_front'
extract.POSTURE_BACK = 'posture_back'
extract.POSTURE_LEFT = 'posture_left'
extract.POSTURE_RIGHT = 'posture_right'
extract.CANDLE_PARTICLES_COUNT = 5

function extract.clicked(state)
  return love.mouse.isDown(1) and not state.mouseDown
end

function extract.isGameOver(state)
  return #state.pizza.slices == 0
end

function extract.aliveMobs(state)
  local aliveMobs = {}

  for __, mob in pairs(state.mobs) do
    if mob.lives > 0 then
      aliveMobs[#aliveMobs + 1] = mob
    end
  end

  return aliveMobs
end

function extract.isLevelCompleted(state)
  return (#state.pizza.slices > 0)
    and (state.schedule.tick.idx >= #state.schedule.series)
    and (#(extract.aliveMobs(state)) == 0)
end

function extract.isGameStopped(state)
  return extract.isGameOver(state) or extract.isLevelCompleted(state)
end

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

function extract.mobsNearTower(tower, state)
  local found = {}

  for _, mob in pairs(state.mobs) do
    if mob.lives > 0 then
      local mobScreenState = extract.mobScreenState(mob)
      local distanceRow = math.abs(tower.tile.row - mobScreenState.row)
      local distanceCol = math.abs(tower.tile.col - mobScreenState.col)
      if distanceCol + distanceRow <= tower.radius then
        table.insert(found, mob.id)
      end
    end
  end

  return found
end

function extract.selectedTower(towers)
  for _, tower in pairs(towers) do
    if tower.selected then
      return tower
    end
  end
end

function extract.isTower(tile, candles)
  for _, candle in pairs(candles) do
    if candle.tile.row == tile.row and candle.tile.col == tile.col then
      return true
    end
  end
  return false
end

function extract.isInMap(tile, map)
  if tile.row > 0 and tile.row <= #map.tiles then
    if tile.col > 0 and tile.col <= #map.tiles[1] then
      return true
    end
  end
  return false
end

function extract.canAddTower(hover, map, candles)
  if not extract.isInMap(hover, map) then
    return false
  end
  local isPath = map.tiles[hover.row][hover.col] == path.PATH_TYPE
  local isTower = extract.isTower(hover, candles)
  return not (isPath or isTower)
end

function extract.towersAvailable(mobs, candles)
  local deadMobs = 0
  for _, mob in pairs(mobs) do
    if mob.lives < 1 then
      deadMobs = deadMobs + 1
    end
  end
  return deadMobs - #candles + 1
end

return extract
