local mapUpdate = require('lib.mapupdate')
local merge = require('lib.merge')

local update = {}

function update.mob(mob, state, dt)
  local hits = 0

  if mob.lives == 0 then
    return mob
  end

  for __, candle in pairs(state.candles) do
    for __, bullet in pairs(candle.bullets) do
      if (bullet.mobId == mob.id) and bullet.touched then
        hits = hits + candle.damages
      end
    end
  end

  if hits == 0 then
    return mob
  elseif hits >= mob.lives then
    local anim = {
      name = 'killed',
      cursor = 0,
      duration = 0.4
    }
    return merge(mob, {lives = 0, anim = anim})
  else
    local anim = {
      name = 'hurt',
      cursor = 0,
      duration = 0.2
    }
    return merge(mob, {lives = mob.lives - hits, anim = anim})
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
    mouseDown = love.mouse.isDown(1),
    candles = mapUpdate(update.candle, state.candles, state, dt),
    mobs = mapUpdate(update.mob, state.mobs, state, dt)
  })
end

return update
