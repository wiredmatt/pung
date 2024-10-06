local Paddle = require("game.objects.paddle")

---@class Ai : Paddle
---@field super Paddle
---@field reaction_time number
---@field last_update number
---@field ball Ball
local Ai = Paddle:extend()

---@param ball Ball
function Ai:new(ball, ...)
    self.color = { 0.2, 0, 0.25, 1 }
    Ai.super.new(self, ...)

    self.reaction_time = love.math.random(0.1, 0.3)
    self.prediction_error = love.math.random(-30, 30)
    self.decision_threshold = love.math.random(self.height / 5, self.height / 3)
    self.last_update = 0
    self.ball = ball
end

function Ai:update(dt)
    self.last_update = self.last_update + dt

    if self.last_update >= self.reaction_time then
        self.last_update = 0
        self.reaction_time = love.math.random(0.1, 0.3)

        local ball_y = self.ball.body:getY() + self.prediction_error
        local paddle_y = self.body:getY()

        if ball_y < paddle_y - self.decision_threshold then
            self.direction = love.math.random(-1, -0.7)
        elseif ball_y > paddle_y + self.decision_threshold then
            self.direction = love.math.random(0.7, 1)
        else
            self.direction = 0
        end

        self.prediction_error = love.math.random(-30, 30)
        self.decision_threshold = love.math.random(self.height / 5, self.height / 3)
    end

    Ai.super.update(self, dt)
end

return Ai