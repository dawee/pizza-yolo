local merge = require('lib.merge')
local color = require('lib.color')
local draw = require('scene.mainmenu.draw')
local update = require('scene.mainmenu.update')

local scene = {}

function scene.load(game)
  -- Set defaults rendering settings
  love.graphics.setDefaultFilter('nearest', 'nearest')

  local windowWidth, windowHeight = love.graphics.getDimensions()
  local mainMenuScene = {
    graphics = {
      fonts = {
        silkscreen = {
          bold_50 = love.graphics.setNewFont('asset/font/slkscreb.ttf', 50),
          normal_30 = love.graphics.setNewFont('asset/font/slkscre.ttf', 30)
        }
      },
      pizza_slices = {
        love.graphics.newImage('asset/pizza/pizza1.png'),
        love.graphics.newImage('asset/pizza/pizza2.png'),
        love.graphics.newImage('asset/pizza/pizza3.png'),
        love.graphics.newImage('asset/pizza/pizza4.png'),
        love.graphics.newImage('asset/pizza/pizza5.png'),
        love.graphics.newImage('asset/pizza/pizza6.png'),
      }
    },
    state = {
      mouseDown = love.mouse.isDown(1),
      hover = {
        x = 0,
        y = 0
      },
      slices = {}
    }
  }

  local slices = {}

  for slice_row = 1, 10 do
    for slice_col = 1, 10 do
      slices[#slices + 1] = {
        turn = {
          idx = 1,
          cursor = (slice_row * slice_col) / 100,
          velocity = 0.2
        },
        x = (slice_col - 1) * 100,
        y = (slice_row - 1) * 100 - 70
      }
    end
  end

  mainMenuScene.state.slices = slices

  local pizza_canvas = love.graphics.newCanvas(16, 16)

  love.graphics.setCanvas(pizza_canvas)
  love.graphics.clear()

  for __, slice in pairs(mainMenuScene.graphics.pizza_slices) do
    love.graphics.draw(slice)
  end

  love.graphics.setCanvas()

  mainMenuScene.graphics.pizza_canvas = pizza_canvas

  return merge(game, {scene = mainMenuScene})
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
  return draw.all(game.scene.graphics, game.scene.state)
end

return scene
