local Object = require("lib.object")

---@class Paddle : Object
---@field x number
---@field y number
---@field width number
---@field height number
---@field scale_x number
---@field scale_y number
---@field image love.Image
---@field color vec4
---@field shader love.Shader
---@field direction number
---@field move_speed number
---@overload fun(...) : Paddle
local Paddle = Object:extend()

Paddle.width, Paddle.height = 17, 120 -- sprite is 17x120

---@param x number
---@param y number
---@param scale_x number
---@param scale_y number
---@param physics_world love.World
function Paddle:new(x, y, scale_x, scale_y, physics_world)
  self.x = x
  self.y = y
  self.scale_x = scale_x
  self.scale_y = scale_y
  self.image = gl.newImage("assets/sprites/paddle.png")

  self.color = self.color or { 0, 0, 0, 1 }
  self.shader = gl.newShader("assets/shaders/color.fs")
  self.shader:send("control", self.color)

  self.shape = physics.newRectangleShape(self.width, self.height)
  self.body = physics.newBody(physics_world, self.x, self.y, "dynamic")
  self.body:setFixedRotation(true)
  self.fixture = physics.newFixture(self.body, self.shape, 0.1)

  self.direction = 0
  self.move_speed = 300
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
