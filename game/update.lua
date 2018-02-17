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

function update.mob(mob, dt)
  local offset = update.computeNewOffset(mob.offset, mob.velocity, dt)

  return {
    velocity = mob.velocity,
    tile = mob.tile,
    offset = mob.offset,
    seenTiles = mob.seenTiles
  }
end

return update
