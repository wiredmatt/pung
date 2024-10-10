local Class = require("lib.class")
local uuid = require("lib.uuid")

---@class GameObject : Object
---@field id string
---@field new fun(self): GameObject
local GameObject = Class('GameObject')

---@class GameObjectWithPhysics : GameObject
---@field fixture love.Fixture
---@field shape love.Shape
---@field body love.Body

function GameObject:initialize()
    self.id = uuid()
end

function GameObject:draw()
end

---@param dt number
function GameObject:update(dt)
end

return GameObject
