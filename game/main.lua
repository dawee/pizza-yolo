local draw = require('draw')
local update = require('update')

----------------------------------------------------------------------------

local game = {
  graphics = {},
  state = {
    mobs = {
      {
        velocity = 1,
        previousTile = {row = 0, col = 3},
        tile = {row = 1, col = 3},
        cursor = 0,
        seenTiles = {}
      }
    },
    map = {
      tiles = {
        {'W', 'W', '_', 'W', 'W', 'W', 'W', 'W'},
        {'W', 'W', '_', '_', '_', '_', '_', 'W'},
        {'W', 'W', 'W', 'W', 'W', 'W', '_', 'W'},
        {'W', '_', '_', '_', '_', '_', '_', 'W'},
        {'W', '_', 'W', 'W', 'W', 'W', 'W', 'W'},
      }
    }
  }
}

----------------------------------------------------------------------------

function love.load()
  -- Set defaults rendering settings
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- Load Images
  game.graphics.tilePath = love.graphics.newImage('asset/tile-path.png')
  game.graphics.tileWall = love.graphics.newImage('asset/tile-wall.png')
  game.graphics.mozza = {
    front = {
      love.graphics.newImage('asset/mozza/mozza-front1.png')
    }
  }
end

function love.update(dt)
  game.state = update.all(game.state, dt)
end

function love.draw()
  draw.all(game.graphics, game.state)
end
