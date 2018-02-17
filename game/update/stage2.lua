local mapUpdate = require('update.mapupdate')
local merge = require('update.merge')

local update = {}

function update.mob(mob, state, dt)
  local hits = 0

  if mob.lives == 0 then
    return mob
  end

  for __, candle in pairs(state.candles) do
    for __, bullet in pairs(candle.bullets) do
      if (bullet.mobId == mob.id) and bullet.touched then
        hits = hits + 1
      end
    end
  end

  if hits == 0 then
    return mob
  elseif hits >= mob.lives then
    return merge(mob, {lives = 0})
  else
    return merge(mob, {lives = mob.lives - hits})
  end
end

function update.candle(candle, state, dt)
  local bullets = {}

  for __, bullet in pairs(candle.bullets) do
    if not bullet.touched then
      bullets[#bullets + 1] = bullet
    end
  end

  return merge(candle, {bullets = bullets})
end

function update.all(state, dt)
  return merge(state, {
    candles = mapUpdate(update.candle, state.candles, state, dt),
    mobs = mapUpdate(update.mob, state.mobs, state, dt)
  })
end

return update
