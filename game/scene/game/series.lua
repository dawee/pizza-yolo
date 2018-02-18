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
    lives = 50,
    velocity = 0.8,
  }
end

local function mushroom()
  return {
    type = 'mushroom',
    lives = 80,
    velocity = 1.6,
  }
end

local function cheddar()
  return {
    type = 'cheddar',
    lives = 800,
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

local function series5()
  return {mozza(), mozza(), olive()}
end

local function series6()
  return {mozza(), mozza(), olive()}
end

local function series7()
  return {olive(), olive()}
end

local function series8()
  return {mozza(), olive(), olive(), mozza(), mozza()}
end

local function series9()
  return {olive(), olive(), mozza(), mozza(), mozza()}
end

local function series10()
  return {mozza(), olive(), olive(), mozza(), mozza()}
end

local function series11()
  return {mushroom(), mozza(), mozza(), mozza()}
end

local function series12()
  return {olive(), olive(), mozza(), mozza()}
end

local function series13()
  return {olive(), olive(), mozza(), mozza()}
end

local function series14()
  return {olive(), olive(), olive(), olive(), olive()}
end

local function series15()
  return {mushroom(), mushroom(), mozza(), mozza()}
end

local function series16()
  return {olive(), olive(), mozza(), mozza(), mozza()}
end

local function series17()
  return {olive(), olive(), mozza(), mozza(), mozza()}
end

local function series18()
  return {mushroom(), mushroom(), mushroom()}
end

local function series19()
  return {olive(), olive(), olive(), olive()}
end

local function series20()
  return {olive(), olive(), olive(), olive()}
end

local function series21()
  return {mushroom(), mushroom(), mushroom(), mushroom()}
end

local function series22()
  return {mozza(), mozza(), mozza(), mozza()}
end

local function series23()
  return {olive(), olive(), olive(), olive()}
end

local function series24()
  return {mushroom(), mushroom(), mushroom(), mushroom(), mushroom(), mushroom()}
end

local function series25()
  return {cheddar()}
end

local function series26()
  return {mushroom(), mushroom(), mushroom(), mushroom(), mushroom(), mushroom()}
end

local function series27()
  return {olive(), olive(), olive(), olive(), olive(), olive()}
end

local function series28()
  return {mushroom(), mushroom(), mushroom(), mushroom(), mushroom(), mushroom()}
end

local function series29()
  return {olive(), olive(), olive(), olive(), olive(), olive()}
end

local function series30()
  return {cheddar(), cheddar()}
end

local function series31()
  return {cheddar(), cheddar()}
end

local function series32()
  return {cheddar(), cheddar(), cheddar(), cheddar()}
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
    series9(),
    series10(),
    {},
    series11(),
    series12(),
    series13(),
    series14(),
    {},
    series15(),
    series16(),
    series17(),
    {},
    series18(),
    series19(),
    series20(),
    {},
    series21(),
    series22(),
    series23(),
    {},
    series24(),
    series25(),
    {},
    series26(),
    series27(),
    {},
    series28(),
    series29(),
    series30(),
    series31(),
    series32(),
  }
end

return createSeries
