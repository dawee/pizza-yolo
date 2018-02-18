local animation = {}

function animation.easeOutSine(start, stop, cursor)
  return (stop - start) * math.sin(cursor * (math.pi / 2)) + start
end

function animation.lerp(a, b, t)
  return (1 - t) * a + t * b
end

return animation
