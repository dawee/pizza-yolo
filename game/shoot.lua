local extract = require('extract')

local shoot = {}

function shoot.findMobsNearTower(tower, state)
  local found = {}

  for _, mob in pairs(state.mobs) do
    if mob.lives > 0 then
      local mobScreenState = extract.mobScreenState(mob)
      local distanceRow = math.abs(tower.tile.row + 0.5 - mobScreenState.row)
      local distanceCol = math.abs(tower.tile.col - mobScreenState.col)
      if distanceCol + distanceRow <= tower.radius then
        table.insert(found, mob.id)
      end
    end
  end

  return found
end

return shoot
