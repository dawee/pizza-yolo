local draw = require('draw')

----------------------------------------------------------------------------

local game = {
  graphics = {
    images = {}
  },
  state = {
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
  love.graphics.setDefaultFilter('nearest', 'nearest')
  game.graphics.images.tilePath = love.graphics.newImage('asset/tile-path.png')
  game.graphics.images.tileWall = love.graphics.newImage('asset/tile-wall.png')
end

function love.draw()
  draw.tiles(game.graphics, game.state)
end
