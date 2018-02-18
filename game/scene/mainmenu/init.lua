local merge = require('lib.merge')
local color = require('lib.color')
local draw = require('scene.mainmenu.draw')
local update = require('scene.mainmenu.update')

local scene = {}

function scene.load(game)
  local mainMenuScene = {
    graphics = {
      fonts = {
        silkscreen = {
          bold_50 = love.graphics.setNewFont('asset/font/slkscreb.ttf', 50),
          normal_30 = love.graphics.setNewFont('asset/font/slkscre.ttf', 30)
        }
      }
    },
    state = {
      hover = {
        x = 0,
        y = 0
      }
    }
  }

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
