local function isDict(value)
  return (type(value) == 'table') and value.__type == 'dict'
end

return isDict
