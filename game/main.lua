local gameScene = require('scene.game')

local game = {}

function love.load()
  game = gameScene.load(game)
end

function love.update(dt)
  game = gameScene.update(game, dt)
end

function love.draw()
  gameScene.draw(game)
end
