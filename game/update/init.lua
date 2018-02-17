local stage1 = require('update.stage1')

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
  all = pipe(stage1.all)
}
