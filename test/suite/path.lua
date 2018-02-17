local path = require('path')
local map1Fixture = require('test.fixture.map1')


local suite = {name = 'Path', tests = {}}

----------------------------------------------

function suite.tests.path1(it)
  local test = it('should find 4 adjacent tiles')

  local function run(assert)
    local adjacentTiles = path.findAdjacentTiles(
      {row = 1, col = 3},
      map1Fixture
    )

    return assert.all(
      assert.is(#adjacentTiles, 1),
      assert.is(adjacentTiles[1].row, 2),
      assert.is(adjacentTiles[1].col, 3)
    )
  end

  return test, run
end

----------------------------------------------

return suite
