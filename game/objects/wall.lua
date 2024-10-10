local GameObject = require "game.objects.game_object"

---@class Wall : GameObject
---@field new fun(self, x: number, y: number, width: number, height: number, physics_world: love.World): Wall
local Wall = Class('Wall', GameObject)

function Wall:initialize(x, y, width, height, physics_world)
    GameObject.initialize(self)

    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.shape = physics.newRectangleShape(self.width, self.height)
    self.body = physics.newBody(physics_world, self.x, self.y, "static")
    self.body:setFixedRotation(true)
    self.fixture = physics.newFixture(self.body, self.shape)
end

return Wall
