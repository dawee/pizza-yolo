local dict = require('magma.dict')
local get = require('magma.get')
local list = require('magma.list')
local pipe = require('magma.pipe')
local reduce = require('magma.reduce')
local set = require('magma.set')
local createActions = require('action.create')
local drawTiles = require('tile.draw')
local drawMobs = require('mob.draw')
local updateMobs = require('mob.update')

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
  }),
  mobs = dict({
    mob1 = dict({
      id = 'mob1',
      position = dict({row = 7, col = 2}),
      seenTiles = list()
    })
  })
})

local images = dict()

local function update(state, action)
  return pipe(
    updateMobs(action)
  )(state)
end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  local tile = dict({
    path = love.graphics.newImage('asset/tile-path.png'),
    wall = love.graphics.newImage('asset/tile-wall.png')
  })

  local mob = love.graphics.newImage('asset/mob/mozza-front1.png')

  images = pipe(
    set('tile', tile),
    set('mob', mob)
  )(images)
end

function love.update(dt)
  local actions = createActions(state, dt)

  state = reduce(update, state, actions)
end

function love.draw()
  drawTiles(images, get('tiles', state))
  drawMobs(images, get('mobs', state))
end
