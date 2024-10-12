local Class = require("lib.class")
local uuid = require("lib.uuid")

---@class GameObject
local GameObject = Class('GameObject')

function GameObject:initialize()
    self.id = uuid()
end

function GameObject:draw()
end

---@param dt number
function GameObject:update(dt)
end

return GameObject
