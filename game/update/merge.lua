return function (defaults, values)
  local merged = {}

  for key, value in pairs(defaults) do
    merged[key] = value
  end

  for key, value in pairs(values) do
    merged[key] = value
  end

  return merged
end
