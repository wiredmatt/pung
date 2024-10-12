local FontsManager = require "game.util.fonts_manager"
local Signals      = require "lib.signals"

--- @class Game
--- @field load fun()
--- @field update fun(dt: number)
--- @field draw fun()
local Game         = {
    title = "Pong",
    ---@type Scene
    current_scene = nil,
}

Game.load          = function()
    window.setTitle(Game.title)
    physics.setMeter(PX_MT)
    FontsManager:load_defaults()
    Signals:clear_all()
    Game.current_scene = nil
    Game.current_scene = require("game.scenes.gameplay")
    Game.current_scene:load()
end

Game.update        = function(dt)
    Game.current_scene:update(dt)
end

Game.draw          = function()
    Game.current_scene:draw()
end

Game.resize        = function()
end

return Game
