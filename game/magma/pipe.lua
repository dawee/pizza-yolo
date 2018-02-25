local function pipe(...)
  local funcs = {...}

  return function (initial)
    local res = initial

    for key, func in pairs(funcs) do
      res = func(res)
    end

    return res
  end
end

return pipe
