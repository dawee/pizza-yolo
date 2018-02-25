local function createPrefixed(func, prefixedArgs)
  return function(...)
    local nextArgs = {...}
    local args = {unpack(prefixedArgs)}

    if #nextArgs == 1 then
      args[#args + 1] = nextArgs[1]
    else
      for index = 1, #nextArgs do
        args[#args + 1] = nextArgs[index]
      end
    end

    return func(unpack(args))
  end
end

local function curry(func, argc)
  return function(...)
    local args = {...}

    if #args < argc then
      local prefixed = createPrefixed(func, args, argc)

      return curry(prefixed, argc - #args)
    else
      return func(unpack(args))
    end
  end
end

return curry
