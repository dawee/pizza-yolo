local list = require('magma.list')
local push = require('magma.push')
local actionType = require('magma.action.type')

local action = {type = actionType}

function action.factory()
  local function createActions(dt)
    local actions = list()

    return push({
      type = action.type.GAME_UPDATE,
      dt = dt
    }, actions)
  end

  return createActions
end


return action
