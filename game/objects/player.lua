local Paddle = require("game.objects.paddle")

---@class Player : Paddle
---@field super Paddle
local Player = Paddle:extend()

function Player:new(...)
    self.color = { 1, 0, 0, 1 }
    self.super.new(self, ...)
end

function Player:update(dt)
    self.super.update(self, dt)
    self:handle_input(dt)
end

function Player:handle_input(dt)
    local up, down = input:down("up"), input:down("down")
    self.direction = up and -1 or down and 1 or 0
end

return Player
