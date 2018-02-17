local update = require('update')
local map1Fixture = require('test.fixture.mob1')


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

return suite
