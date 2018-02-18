local stage1 = require('update.stage1')
local stage2 = require('update.stage2')
local stage3 = require('update.stage3')

function pipe(...)
  local funcs = {...}

  return function (state, dt)
    local newState = state

    for key, func in pairs(funcs) do
      newState = func(newState, dt)
    end

    return newState
  end
end

return {
  all = pipe(stage1.all, stage2.all, stage3.all)
}
