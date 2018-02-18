local merge = require('lib.merge')
local mapUpdate = require('lib.mapupdate')
local cycle = require('lib.cycle')
local extract = require('scene.mainmenu.extract')

local update = {}

function update.slice(slice, state, dt)
  return merge(slice, {
    turn = cycle.run(slice.turn, dt)
  })
end

function update.hover(hover, state, dt)
  local x, y = love.mouse.getPosition()

  return {x = x, y = y}
end

function update.all(state, dt)
  return merge(state, {
    mouseDown = love.mouse.isDown(1),
    hover = update.hover(state.hover, state, dt),
    slices = mapUpdate(update.slice, state.slices, state, dt)
  })
end

function update.navigation(navigation, game, dt)
  local scene = navigation.scene

  if extract.clicked(game.scene.state) then
    scene = 'game'
  end

  return merge(navigation, {
    scene = scene
  })
end

return update
