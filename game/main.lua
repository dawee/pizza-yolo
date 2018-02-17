local draw = require('draw')
local update = require('update')

----------------------------------------------------------------------------

local game = {
  graphics = {},
  state = {
    candles = {
      {
        burn = {
          velocity = 2,
          cursor = 0
        },
        tile = {row = 2, col = 2}
      },
      {
        burn = {
          velocity = 2,
          cursor = 0.5
        },
        tile = {row = 4, col = 8}
      }
    },
    mobs = {
      {
        velocity = 0.8,
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
      love.graphics.newImage('asset/mozza/mozza-front1.png'),
      love.graphics.newImage('asset/mozza/mozza-front2.png'),
      love.graphics.newImage('asset/mozza/mozza-front3.png')
    },
    back = {
      love.graphics.newImage('asset/mozza/mozza-back1.png'),
      love.graphics.newImage('asset/mozza/mozza-back2.png'),
      love.graphics.newImage('asset/mozza/mozza-back3.png'),
    },
    profile = {
      love.graphics.newImage('asset/mozza/mozza-profile1.png'),
      love.graphics.newImage('asset/mozza/mozza-profile2.png'),
      love.graphics.newImage('asset/mozza/mozza-profile3.png'),
    }
  }

  game.graphics.candle = {
    love.graphics.newImage('asset/candle/candle1.png'),
    love.graphics.newImage('asset/candle/candle2.png'),
    love.graphics.newImage('asset/candle/candle3.png')
  }
end

function love.update(dt)
  game.state = update.all(game.state, dt)
end

function love.draw()
  draw.all(game.graphics, game.state)
end
