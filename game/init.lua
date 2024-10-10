local FontsManager = require "game.util.fonts_manager"
--- @class Game
--- @field load fun()
--- @field update fun(dt: number)
--- @field draw fun()
local Game = {
    title = "Orbit Raiders",
    ---@type Scene
    current_scene = nil,
}

Game.load = function()
    window.setTitle(Game.title)
    gl.setDefaultFilter('nearest', 'nearest')
    FontsManager:load_defaults()
    Game.current_scene = require("game.scenes.gameplay")
    Game.current_scene:load()
end

Game.update = function(dt)
    Game.current_scene:update(dt)
end

Game.draw = function()
    Game.current_scene:draw()
end

Game.resize = function()
end

return Game
