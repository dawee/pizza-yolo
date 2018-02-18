local draw = require('scene.game.draw')
local update = require('scene.game.update')
local createSeries = require('scene.game.series')
local merge = require('lib.merge')

local scene = {}

function scene.load(game)
  -- Set defaults rendering settings
  love.graphics.setDefaultFilter('nearest', 'nearest')

  local gameScene = {
    graphics = {
      fonts = {
        silkscreen = {
          bold_50 = love.graphics.setNewFont('asset/font/slkscreb.ttf', 50),
          normal_30 = love.graphics.setNewFont('asset/font/slkscre.ttf', 30),
          normal_25 = love.graphics.setNewFont('asset/font/slkscre.ttf', 25)
        }
      }
    },
    state = {
      mouseDown = love.mouse.isDown(1),
      candles = {},
      schedule = {
        tick = {
          idx = 1,
          cursor = 0,
          velocity = 0.08
        },
        series = createSeries()
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
          {'W', '_', '_', '_', '_', 'W', 'W', '_', '_', '_', 'W'},
          {'W', '_', 'W', 'W', '_', 'W', 'W', '_', 'W', 'W', 'W'},
          {'W', '_', 'W', 'W', '_', 'W', 'W', '_', 'W', 'W', 'W'},
          {'W', '_', 'W', 'W', '_', '_', '_', '_', 'W', 'W', 'W'},
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
            selected = false,
            price = 2,
            radius = 1,
            burn = {
              idx = 0,
              velocity = 2,
              cursor = 0
            },
            shoot = {
              idx = 0,
              velocity = 1.2,
              cursor = 0
            },
            bulletVelocity = 2,
            damages = 2
          },
          {
            type = 'greenCandle',
            available = false,
            selected = false,
            price = 6,
            radius = 2,
            burn = {
              idx = 0,
              velocity = 2,
              cursor = 0
            },
            shoot = {
              idx = 0,
              velocity = 1.5,
              cursor = 0
            },
            bulletVelocity = 2,
            damages = 6
          },
          {
            type = 'blueCandle',
            available = false,
            selected = false,
            price = 14,
            radius = 3,
            burn = {
              idx = 0,
              velocity = 2,
              cursor = 0
            },
            shoot = {
              idx = 0,
              velocity = 2.5,
              cursor = 0
            },
            bulletVelocity = 4,
            damages = 5
          },
          {
            type = 'purpleCandle',
            available = false,
            selected = false,
            price = 30,
            radius = 6,
            burn = {
              idx = 0,
              velocity = 2,
              cursor = 0
            },
            shoot = {
              idx = 0,
              velocity = 0.4,
              cursor = 0
            },
            bulletVelocity = 1.2,
            damages = 100
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
      love.graphics.newImage('asset/mob/mozza-front1.png'),
      love.graphics.newImage('asset/mob/mozza-front2.png'),
      love.graphics.newImage('asset/mob/mozza-front3.png')
    },
    back = {
      love.graphics.newImage('asset/mob/mozza-back1.png'),
      love.graphics.newImage('asset/mob/mozza-back2.png'),
      love.graphics.newImage('asset/mob/mozza-back3.png'),
    },
    profile = {
      love.graphics.newImage('asset/mob/mozza-profile1.png'),
      love.graphics.newImage('asset/mob/mozza-profile2.png'),
      love.graphics.newImage('asset/mob/mozza-profile3.png'),
    }
  }

  gameScene.graphics.cheddar = {
    front = {
      love.graphics.newImage('asset/mob/cheddar-front1.png'),
      love.graphics.newImage('asset/mob/cheddar-front2.png'),
      love.graphics.newImage('asset/mob/cheddar-front3.png')
    },
    back = {
      love.graphics.newImage('asset/mob/cheddar-back1.png'),
      love.graphics.newImage('asset/mob/cheddar-back2.png'),
      love.graphics.newImage('asset/mob/cheddar-back3.png'),
    },
    profile = {
      love.graphics.newImage('asset/mob/cheddar-profile1.png'),
      love.graphics.newImage('asset/mob/cheddar-profile2.png'),
      love.graphics.newImage('asset/mob/cheddar-profile3.png'),
    }
  }

  gameScene.graphics.mushroom = {
    front = {
      love.graphics.newImage('asset/mob/mushroom-front1.png'),
      love.graphics.newImage('asset/mob/mushroom-front2.png'),
      love.graphics.newImage('asset/mob/mushroom-front3.png')
    },
    back = {
      love.graphics.newImage('asset/mob/mushroom-back1.png'),
      love.graphics.newImage('asset/mob/mushroom-back2.png'),
      love.graphics.newImage('asset/mob/mushroom-back3.png'),
    },
    profile = {
      love.graphics.newImage('asset/mob/mushroom-profile1.png'),
      love.graphics.newImage('asset/mob/mushroom-profile2.png'),
      love.graphics.newImage('asset/mob/mushroom-profile3.png'),
    }
  }

  gameScene.graphics.olive = {
    front = {
      love.graphics.newImage('asset/mob/olive-front1.png'),
      love.graphics.newImage('asset/mob/olive-front2.png'),
      love.graphics.newImage('asset/mob/olive-front3.png')
    },
    back = {
      love.graphics.newImage('asset/mob/olive-back1.png'),
      love.graphics.newImage('asset/mob/olive-back2.png'),
      love.graphics.newImage('asset/mob/olive-back3.png'),
    },
    profile = {
      love.graphics.newImage('asset/mob/olive-profile1.png'),
      love.graphics.newImage('asset/mob/olive-profile2.png'),
      love.graphics.newImage('asset/mob/olive-profile3.png'),
    }
  }

  gameScene.graphics.candle = {
    love.graphics.newImage('asset/candle/candle1.png'),
    love.graphics.newImage('asset/candle/candle2.png'),
    love.graphics.newImage('asset/candle/candle3.png')
  }

  gameScene.graphics.greenCandle = {
    love.graphics.newImage('asset/candle/candle-green1.png'),
    love.graphics.newImage('asset/candle/candle-green2.png'),
    love.graphics.newImage('asset/candle/candle-green3.png')
  }

  gameScene.graphics.blueCandle = {
    love.graphics.newImage('asset/candle/candle-blue1.png'),
    love.graphics.newImage('asset/candle/candle-blue2.png'),
    love.graphics.newImage('asset/candle/candle-blue3.png')
  }

  gameScene.graphics.purpleCandle = {
    love.graphics.newImage('asset/candle/candle-purple1.png'),
    love.graphics.newImage('asset/candle/candle-purple2.png'),
    love.graphics.newImage('asset/candle/candle-purple3.png')
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
    navigation = update.navigation(game.navigation, game, dt),
    scene = merge(game.scene, {
      state = update.all(game.scene.state, dt)
    })
  })
end

function scene.draw(game)
  draw.all(game.scene.graphics, game.scene.state)
end

return scene
