return function (updater, iteratee, ...)
  local args = {...}
  local updated = {}

  for __, item in pairs(iteratee) do
    updated[#updated + 1] = updater(item, unpack(args))
  end

  return updated
end
