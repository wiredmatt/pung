local Object = require "lib.object"

---@class Wall
local Wall = Object:extend()

function Wall:new(x, y, width, height, physics_world)
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
