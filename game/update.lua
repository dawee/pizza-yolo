local path = require('path')

local update = {}

function update.capZero(previousValue, nextValue)
  local isNotCrossingZero = (previousValue > 0 and nextValue > 0)
    or (previousValue < 0 and nextValue < 0)

  if isNotCrossingZero then
    return nextValue
  end

  return 0
end

function update.computeNewOffset(offset, velocity, dt)
  return {
    row = update.capZero(offset.row, offset.row - offset.row * velocity * dt),
    col = update.capZero(offset.col, offset.col - offset.col * velocity * dt)
  }
end

function update.mob(mob, state, dt)
  local offset = update.computeNewOffset(mob.offset, mob.velocity, dt)
  local nextTile = mob.tile
  local seenTiles = mob.seenTiles

  if (offset.row == 0) and (offset.col == 0) then
    local seenTiles = {unpack(seenTiles)}

    seenTiles[#seenTiles + 1] = mob.tile
    nextTile = path.findNextTile(mob, state.map)
    offset = {
      row = mob.tile.row - nextTile.row,
      col = mob.tile.col - nextTile.col
    }
  end

  return {
    velocity = mob.velocity,
    tile = nextTile,
    offset = offset,
    seenTiles = seenTiles
  }
end

return update
