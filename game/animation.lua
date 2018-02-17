local animation = {}

function animation.easeOutSine(start, stop, cursor)
  return (stop - start) * math.sin(cursor * (math.pi / 2)) + start;
end

return animation
