local GameObject = require "game.objects.game_object"

---@class Paddle : GameObject
---@field color vec4
---@field new fun(x: number, y: number, scale_x: number, scale_y: number, physics_world: love.World): Paddle
local Paddle = Class('Paddle', GameObject)
-- sprite is 17x120
Paddle.width = 17
Paddle.height = 120

---@param color vec4
---@param x number
---@param y number
---@param scale_x number
---@param scale_y number
---@param physics_world love.World
function Paddle:initialize(color, x, y, scale_x, scale_y, physics_world)
  GameObject.initialize(self)

  self.direction = 0
  self.move_speed = 300

  self.x = x
  self.y = y
  self.scale_x = scale_x
  self.scale_y = scale_y
  self.image = gl.newImage("assets/sprites/paddle.png")

  self.color = color or { 0, 0, 0, 1 }
  self.shader = gl.newShader("assets/shaders/color.fs")
  self.shader:send("control", self.color)

  self.shape = physics.newRectangleShape(self.width, self.height)
  self.body = physics.newBody(physics_world, self.x, self.y, "dynamic")
  self.body:setFixedRotation(true)
  self.fixture = physics.newFixture(self.body, self.shape, 0.1)
end

function Paddle:draw()
  ---@format disable
  gl.setShader(self.shader)
    gl.draw(
      self.image,
      self.body:getX() - ((self.width / 2) * self.scale_x), self.body:getY() - ((self.height / 2) * self.scale_y),
      0,
      self.scale_x, self.scale_y
    )
  gl.setShader()
  ---@format enable
end

function Paddle:update(dt)
  self.body:setLinearVelocity(0, self.direction * self.move_speed)
end

return Paddle
