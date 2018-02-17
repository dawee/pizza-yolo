local shoot = require('shoot')
local mob1Fixture = require('test.fixture.mob1')
local mob2Fixture = require('test.fixture.mob2')
local candle1Fixture = require('test.fixture.candle1')


local suite = {name = 'Shoot', tests = {}}

----------------------------------------------

function suite.tests.shoot1(it)
  local test = it('should find only mobs near tower')

  local function run(assert)
    local state = {mobs = {mob1Fixture, mob2Fixture}}
    local mobsIds = shoot.findMobsNearTower(candle1Fixture, state)

    return assert.all(
      assert.is(#mobsIds, 1),
      assert.is(mobsIds[1], 1)
    )
  end

  return test, run
end

----------------------------------------------

return suite
