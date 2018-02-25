local function isList(value)
  return (type(value) == 'table') and value.__type == 'list'
end

return isList
