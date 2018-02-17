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

function suite.tests.path2(it)
  local test = it('should find next tile in path')

  local function run(assert)
    local nextTile = path.findNextTile(
      {tile = {row = 1, col = 3}, seenTiles = {}},
      map1Fixture
    )

    return assert.all(
      assert.is(nextTile.row, 2),
      assert.is(nextTile.col, 3)
    )
  end

  return test, run
end

----------------------------------------------

function suite.tests.path3(it)
  local test = it('should find only unseen tile in path')

  local function run(assert)
    local nextTile = path.findNextTile(
      {
        tile = {row = 2, col = 3},
        seenTiles = {
          {row = 1, col = 3}
        }
      },
      map1Fixture
    )

    return assert.all(
      assert.is(nextTile.row, 2),
      assert.is(nextTile.col, 4)
    )
  end

  return test, run
end

----------------------------------------------

return suite
