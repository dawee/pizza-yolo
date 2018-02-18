-- Mobs types

local function mozza()
  return {
    type = 'mozza',
    lives = 4,
    velocity = 0.8,
  }
end

local function olive()
  return {
    type = 'olive',
    lives = 70,
    velocity = 0.8,
  }
end

local function mushroom()
  return {
    type = 'mushroom',
    lives = 60,
    velocity = 1.6,
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

local function series5()
  return {mozza(), olive(), mozza()}
end

local function series6()
  return {mozza(), olive(), mozza()}
end

local function series7()
  return {olive(), olive()}
end

local function series8()
  return {olive(), olive()}
end

local function series9()
  return {olive(), olive(), mushroom()}
end

local function createSeries()
  return {
    series1(),
    series2(),
    series3(),
    series4(),
    series5(),
    series6(),
    series7(),
    series8(),
    series9()
  }
end

return createSeries
