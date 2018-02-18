-- Mobs types

local function mozza()
  return {
    type = 'mozza',
    lives = 8,
    velocity = 0.8,
  }
end

-- Series

local function series1()
  return {mozza()}
end

local function series2()
  return {mozza()}
end

local function series3()
  return {mozza(), mozza()}
end

local function series4()
  return {mozza(), mozza()}
end

local function createSeries()
  return {
    series1(),
    series2(),
    series3(),
    series4()
  }
end

return createSeries
