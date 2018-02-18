local draw = require('scene.game.draw')
local update = require('scene.game.update')
local merge = require('lib.merge')

local scene = {}

function scene.load(game)
  -- Set defaults rendering settings
  love.graphics.setDefaultFilter('nearest', 'nearest')

  local gameScene = {
    graphics = {},
    state = {
      candles = {},
      schedule = {
        tick = {
          idx = 1,
          cursor = 0,
          velocity = 0.1
        },
        series = {
          {
            {
              lives = 8,
              velocity = 0.8,
            },
            {
              lives = 8,
              velocity = 0.8,
            },
          },
          {
            {
              lives = 8,
              velocity = 0.8,
            },
            {
              lives = 8,
              velocity = 0.8,
            },
            {
              lives = 8,
              velocity = 0.8,
            },
          },
          {
            {
              lives = 8,
              velocity = 0.8,
            },
            {
              lives = 8,
              velocity = 0.8,
            },
            {
              lives = 8,
              velocity = 0.8,
            },
          }
        }
      },
      mobs = {},
      pizza = {
        slices = {1, 2, 3, 4, 5, 6, 7, 8},
        tile = {row = 14, col = 2}
      },
      map = {
        tiles = {
          {'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'},
          {'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'},
          {'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'},
          {'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'},
          {'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'},
          {'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'},
          {'W', 'W', '_', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'},
          {'W', 'W', '_', '_', '_', '_', '_', '_', '_', '_', 'W'},
          {'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', '_', 'W'},
          {'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', '_', 'W'},
          {'W', '_', '_', '_', '_', 'W', 'W', 'W', 'W', '_', 'W'},
          {'W', '_', 'W', 'W', '_', 'W', '_', '_', '_', '_', 'W'},
          {'W', '_', 'W', 'W', '_', 'W', '_', 'W', 'W', 'W', 'W'},
          {'W', '_', 'W', 'W', '_', '_', '_', 'W', 'W', 'W', 'W'},
          {'W', '_', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'},
          {'.', '_', '.', '.', '.', '.', '.', '.', '.', '.', '.'},
          {'.', '_', '.', '.', '.', '.', '.', '.', '.', '.', '.'},
        }
      },
      ui = {
        towers = {
          {
            type = 'candle',
            available = true,
            selected = false
          }
        }
      },
      hover = {
        row = 0,
        col = 0
      }
    }
  }

  -- Load Images
  gameScene.graphics.tilePath = love.graphics.newImage('asset/tile-path.png')
  gameScene.graphics.tileWall = love.graphics.newImage('asset/tile-wall.png')

  gameScene.graphics.mozza = {
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

  gameScene.graphics.candle = {
    love.graphics.newImage('asset/candle/candle1.png'),
    love.graphics.newImage('asset/candle/candle2.png'),
    love.graphics.newImage('asset/candle/candle3.png')
  }

  gameScene.graphics.pizza = {
    love.graphics.newImage('asset/pizza/pizza1.png'),
    love.graphics.newImage('asset/pizza/pizza2.png'),
    love.graphics.newImage('asset/pizza/pizza3.png'),
    love.graphics.newImage('asset/pizza/pizza4.png'),
    love.graphics.newImage('asset/pizza/pizza5.png'),
    love.graphics.newImage('asset/pizza/pizza6.png'),
    love.graphics.newImage('asset/pizza/pizza7.png'),
    love.graphics.newImage('asset/pizza/pizza8.png')
  }

  gameScene.graphics.ui = {
    button = {
      love.graphics.newImage('asset/button.png'),
      love.graphics.newImage('asset/button-selected.png')
    }
  }

  return merge(game, {scene = gameScene})
end

function scene.update(game, dt)
  return merge(game, {
    scene = merge(game.scene, {
      state = update.all(game.scene.state, dt)
    })
  })
end

function scene.draw(game)
  draw.all(game.scene.graphics, game.scene.state)
end

return scene
