local function popCount(x)
  x = x - bit.band(bit.arshift(x, 1), 0x55555555)
  x = bit.band(x, 0x33333333) + bit.band(bit.arshift(x, 2), 0x33333333)
  x = bit.band((x + bit.arshift(x, 4)), 0x0f0f0f0f)
  x = x + bit.arshift(x, 8)
  x = x + bit.arshift(x, 16)

  return bit.band(x, 0x7f) + 1
end

return popCount
