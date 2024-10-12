local GameObject           = require "game.objects.game_object"
local WithPhysicsCallbacks = require "game.objects.mix.with_physics_callbacks"
local Signals              = require "lib.signals"
local EVENTS               = require "game.constant.events"

---@class Ball : GameObjectWithMaybePhysicsCallbacks
---@field new fun(self, color: vec4?, physics_world: love.World): Ball
local Ball                 = Class('Ball', GameObject)
Ball:include(WithPhysicsCallbacks)

---@param color vec4?
---@param physics_world love.World
function Ball:initialize(color, physics_world)
    GameObject.initialize(self)

    self.radius = 15 -- sprite is 30x30 px

    self.particles = {}

    self.move_speed = 300

    self.x = (VIRTUAL_WIDTH / 2)
    self.y = (VIRTUAL_HEIGHT / 2)
    self.image = gl.newImage("assets/sprites/ball.png")
    self.color = color or { 0, 0, 0, 1 }
    self.shader = gl.newShader("assets/shaders/color.fs")
    self.shader:send("control", self.color)

    self.shape = physics.newCircleShape(self.radius)
    self.body = physics.newBody(physics_world, self.x, self.y, "dynamic")
    self.fixture = physics.newFixture(self.body, self.shape, 0.1)
    self:reset()

    self:register_physics_callbacks()

    self:register_launch_signal()
end

function Ball:register_launch_signal()
    local signal = Signals:new(EVENTS.LAUNCH_BALL)

    Signals:subscribe(signal.id, function()
        self:launch()
    end)
end

function Ball:reset()
    self.body:setPosition((VIRTUAL_WIDTH / 2), (VIRTUAL_HEIGHT / 2))
    self.body:setLinearVelocity(0, 0)
    self.body:setAngularVelocity(0)
    self.body:setAngle(0)
    self.velocity_x = 0
    self.velocity_y = 0
end

function Ball:launch()
    local angle = math.random() * (math.pi / 4) - (math.pi / 8) -- Random angle between -22.5 and 22.5 degrees
    local direction_x = math.random(2) == 1 and 1 or -1
    local direction_y = math.random(2) == 1 and 1 or -1

    local vx = math.cos(angle) * self.move_speed * direction_x
    local vy = math.sin(angle) * self.move_speed * direction_y

    self.body:setLinearVelocity(vx, vy)
end

function Ball:draw()
    -- Draw particles
    for _, particle in ipairs(self.particles) do
        gl.setColor(particle.color[1], particle.color[2], particle.color[3], particle.alpha)
        gl.circle("fill", particle.x, particle.y, particle.size)
    end
    gl.setColor(1, 1, 1, 1) -- Reset color


    ---@format disable
    gl.setShader(self.shader)
        gl.draw(
            self.image,
            self.body:getX() - self.radius, self.body:getY() - self.radius
        )
    gl.setShader()
    ---@format enable
end

function Ball:update(dt)
    -- Update particles
    for i = #self.particles, 1, -1 do
        local particle = self.particles[i]
        particle.lifetime = particle.lifetime - dt
        if particle.lifetime <= 0 then
            table.remove(self.particles, i)
        else
            particle.x = particle.x + particle.vx * dt
            particle.y = particle.y + particle.vy * dt
            particle.size = particle.size - dt * 2   -- Shrink over time
            particle.alpha = particle.alpha - dt * 2 -- Fade out over time
        end
    end

    -- Emit new particles
    local particle = {
        x = self.body:getX(),
        y = self.body:getY(),
        vx = math.random(-30, 30),
        vy = math.random(-30, 30),
        size = math.random(4, 8),
        lifetime = 0.5,
        alpha = 1,
        color = { math.random(), math.random(), math.random(), 1 }
    }
    table.insert(self.particles, particle)
end

---@type ContactCallback
function Ball:begin_contact(a, b, coll)
    local nx, ny = coll:getNormal()
    local vx, vy = self.body:getLinearVelocity()

    if math.abs(nx) > 0 then
        vx = -vx
    end

    if math.abs(ny) > 0 then
        vy = -vy
    end

    self.body:setLinearVelocity(vx, vy)
end

return Ball
