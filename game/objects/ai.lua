local Paddle = require("game.objects.paddle")

---@class Ai : Paddle
---@field new fun(self, ball, ...): Ai
local Ai = Class('Ai', Paddle)

---@param ball Ball
function Ai:initialize(ball, ...)
    Paddle.initialize(self, { 0.2, 0, 0.25, 1 }, ...)

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

    Paddle.update(self, dt)
end

return Ai
