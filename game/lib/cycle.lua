local merge = require('lib.merge')

local cycle = {}

function cycle.isNew(animation)
  return animation.cursor == 0
end

function cycle.run(animation, dt)
  local cursor = animation.cursor + animation.velocity * dt
  local idx = animation.idx

  if cursor >= 1 then
    cursor = 0
    idx = idx + 1
  end

  return merge(animation, {cursor = cursor, idx = idx})
end

return cycle
