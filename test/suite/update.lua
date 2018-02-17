local update = require('update')
local mob1Fixture = require('test.fixture.mob1')
local map1Fixture = require('test.fixture.map1')


local suite = {name = 'Update state', tests = {}}

----------------------------------------------

function suite.tests.update1(it)
  local test = it('should update offsets using velocity')

  local function run(assert)
    local offset = update.computeNewOffset(
      {row = -1, col = 0},
      1,
      0.5
    )

    return assert.all(
      assert.is(offset.row, -0.5),
      assert.is(offset.col, 0)
    )
  end

  return test, run
end

----------------------------------------------

function suite.tests.update2(it)
  local test = it('should move to next tile')

  local function run(assert)
    local mob = update.mob(mob1Fixture, {map = map1Fixture}, 1)

    return assert.all(
      assert.is(mob.tile.row, 2),
      assert.is(mob.tile.col, 3),
      assert.is(#mob.seenTiles, 1)
    )
  end

  return test, run
end

----------------------------------------------

return suite
