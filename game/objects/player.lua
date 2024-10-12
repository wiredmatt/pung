local Paddle = require("game.objects.paddle")

---@class Player : Paddle
---@field super Paddle
---@field new fun(self, ...): Player
local Player = Class('Player', Paddle)

function Player:initialize(...)
    Paddle.initialize(self, { 1, 0, 0, 1 }, ...)
end

function Player:update(dt)
    self:handle_input(dt)

    Paddle.update(self, dt)
end

function Player:handle_input(dt)
    local up, down = input:down("up"), input:down("down")
    self.direction = up and -1 or down and 1 or 0
end

return Player
