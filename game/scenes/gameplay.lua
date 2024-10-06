local Player = require "game.objects.player"
local Ai = require "game.objects.ai"
local Ball = require "game.objects.ball"
local Wall = require "game.objects.wall"
local Bg = require "game.objects.bg"

local TestScene = {
    ---@type Bg
    bg = nil,
    ---@type Player
    player = nil,
    ---@type Ai
    ai = nil,
    ---@type love.World
    physics_world = nil,
    ---@type Ball
    ball = nil,
    ---@type Wall[]
    walls = {}
}

function TestScene:load()
    physics.setMeter(PX_MT)
    self.physics_world = physics.newWorld(0, 0, true)

    self.bg = Bg("assets/sprites/board.png")

    self.ball = Ball({ 1, 1, 1, 1 }, self.physics_world)

    self.player = Player(
        (Player.width), (VIRTUAL_HEIGHT / 2),
        1, 1,
        self.physics_world
    )

    self.ai = Ai(
        self.ball,
        VIRTUAL_WIDTH - (Ai.width), (VIRTUAL_HEIGHT / 2),
        -1, 1,
        self.physics_world
    )

    self.walls = {
        Wall(VIRTUAL_WIDTH / 2, -5, VIRTUAL_WIDTH, 10, self.physics_world),
        Wall(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT + 5, VIRTUAL_WIDTH, 10, self.physics_world)
    }

    self.physics_world:setCallbacks(
        function(a, b, coll)
            if a:getUserData() == "ball" or b:getUserData() == "ball" then
                self.ball:beginContact(a, b, coll)
            end
        end,
        function()
        end
    )

    self.ball:launch()
end

function TestScene:draw()
    self.bg:draw()
    self.player:draw()
    self.ai:draw()
    self.ball:draw()

    if debug_physics ~= nil then
        debug_physics(self.physics_world, 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    end
end

function TestScene:update(dt)
    self.player:update(dt)
    self.ai:update(dt)
    self.ball:update(dt)
    self.physics_world:update(dt)
end

return TestScene
