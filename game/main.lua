local scenes = {
  game = require('scene.game'),
  mainMenu = require('scene.mainmenu'),
}

local game = {
  navigation = {
    scene = 'mainMenu'
  }
}

local ACCELERATED = tonumber(os.getenv("ACCELERATED") or 1)

local function load(scene)
  local skip = (not scene)
    or (not scene.load)
    or (game.navigation.scene == game.navigation.loadedScene)

  if skip then
    return game
  end

  loadedGame = scene.load(game)
  loadedGame.navigation.loadedScene = game.navigation.scene

  return loadedGame
end

function love.load()
  local scene = scenes[game.navigation.scene]

  game = load(scene)
end

function love.update(dt)
  local scene = scenes[game.navigation.scene]

  game = load(scene)

  for index = 1, ACCELERATED do
    game = scene.update and scene.update(game, dt) or game
  end
end

function love.draw()
  local scene = scenes[game.navigation.scene]

  return scene.draw and (game.navigation.scene == game.navigation.loadedScene) and scene.draw(game)
end
