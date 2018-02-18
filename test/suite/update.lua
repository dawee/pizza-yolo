local update = require('update.stage1')
local mob1Fixture = require('test.fixture.mob1')
local map1Fixture = require('test.fixture.map1')


local suite = {name = 'Update state', tests = {}}

----------------------------------------------

function suite.tests.update1(it)
  local test = it('should move to next tile')

  local function run(assert)
    local mob = update.mob(mob1Fixture, {map = map1Fixture, pizza = { slices = {1, 2, 3, 4, 5, 6, 7, 8}, tile = {5, 5} }}, 1)

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
