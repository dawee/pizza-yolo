local extract = require('scene.game.extract')
local merge = require('lib.merge')
local pipe = require('lib.pipe')
local stages = {
  require('scene.game.update.stage1').all,
  require('scene.game.update.stage2').all,
  require('scene.game.update.stage3').all
}

local update = {}

update.all = pipe(unpack(stages))

function update.navigation(navigation, game, dt)
  if extract.clicked(game.scene.state) and extract.isGameOver(game.scene.state) then
    return merge(navigation, {scene = 'mainMenu'})
  end

  return navigation
end

return update
