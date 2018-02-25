local dict = require('magma.dict')
local get = require('magma.get')
local list = require('magma.list')
local set = require('magma.set')
local tile = require('tile')

local state = dict({
  tiles = list({
    list({'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'}),
    list({'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'}),
    list({'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'}),
    list({'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'}),
    list({'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'}),
    list({'.', '.', '_', '.', '.', '.', '.', '.', '.', '.', '.'}),
    list({'W', 'W', '_', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'}),
    list({'W', 'W', '_', '_', '_', '_', '_', '_', '_', '_', 'W'}),
    list({'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', '_', 'W'}),
    list({'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', '_', 'W'}),
    list({'W', '_', '_', '_', '_', 'W', 'W', '_', '_', '_', 'W'}),
    list({'W', '_', 'W', 'W', '_', 'W', 'W', '_', 'W', 'W', 'W'}),
    list({'W', '_', 'W', 'W', '_', 'W', 'W', '_', 'W', 'W', 'W'}),
    list({'W', '_', 'W', 'W', '_', '_', '_', '_', 'W', 'W', 'W'}),
    list({'W', '_', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W', 'W'}),
    list({'.', '_', '.', '.', '.', '.', '.', '.', '.', '.', '.'}),
    list({'.', '_', '.', '.', '.', '.', '.', '.', '.', '.', '.'}),
  })
})

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  state = set('graphics', dict({
    tile = dict({
      path = love.graphics.newImage('asset/tile-path.png'),
      wall = love.graphics.newImage('asset/tile-wall.png')
    })
  }), state)
end

function love.draw()
  tile.drawAll(state)
end
