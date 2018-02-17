local shoot = {}

function shoot.findMobsNearTower(tower, state)
  -- tower.radius
  local found = {}
  for _, mob in pairs(state.mobs) do
    local distanceRow = math.abs(tower.tile.row - mob.tile.row)
    local distanceCol = math.abs(tower.tile.col - mob.tile.col)
    if distanceCol + distanceRow <= tower.radius then
      table.insert(found, mob.id)
    end
  end
  print(found)

  return found -- returns a list of mob ids
end

return shoot
