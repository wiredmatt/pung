local Player       = require "game.objects.player"
local Ai           = require "game.objects.ai"
local Ball         = require "game.objects.ball"
local Wall         = require "game.objects.wall"
local Bg           = require "game.objects.bg"
local FontsManager = require "game.util.fonts_manager"
local ERS          = require "game.util.escape_rs"
local Signals      = require "lib.singals"

local TestScene    = {
    ---@type { [string]: GameObject }[]
    nodes = {},
    ---@type love.World
    physics_world = nil
}

function TestScene:load()
    physics.setMeter(PX_MT)
    self.physics_world = physics.newWorld(0, 0, true)
    self.nodes = {}

    table.insert(self.nodes, Bg:new("assets/sprites/board.png"))

    local ball = Ball:new({ 1, 1, 1, 1 }, self.physics_world)
    table.insert(self.nodes, ball)

    table.insert(self.nodes, Player(
        (Player.width), (VIRTUAL_HEIGHT / 2),
        1, 1,
        self.physics_world
    ))

    table.insert(self.nodes, Ai(
        ball,
        VIRTUAL_WIDTH - (Ai.width), (VIRTUAL_HEIGHT / 2),
        -1, 1,
        self.physics_world
    ))

    table.insert(self.nodes, Wall(VIRTUAL_WIDTH / 2, -5, VIRTUAL_WIDTH, 10, self.physics_world))
    table.insert(self.nodes, Wall(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT + 5, VIRTUAL_WIDTH, 10, self.physics_world))

    self.physics_world:setCallbacks(
        function(a, b, coll)
            local aId = a:getUserData()
            local bId = b:getUserData()
            if aId then
                Signals:emit(aId .. "_begin_contact", a, b, coll)
            end
            if bId then
                Signals:emit(bId .. "_begin_contact", b, a, coll)
            end
        end,
        function(a, b, coll)
            local aId = a:getUserData()
            local bId = b:getUserData()
            if aId then
                Signals:emit(aId .. "_end_contact", a, b, coll)
            end
            if bId then
                Signals:emit(bId .. "_end_contact", b, a, coll)
            end
        end
    )

    ball:launch()
end

function TestScene:draw()
    for _, node in ipairs(self.nodes) do
        node:draw()
    end

    ERS:queue_draw(function()
        FontsManager:set("teko", "bold", "large")
        gl.print("0", 10, 10)
        FontsManager:unset()
    end)

    if debug_physics ~= nil then
        debug_physics(self.physics_world, 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    end
end

function TestScene:update(dt)
    self.physics_world:update(dt)
    for _, node in ipairs(self.nodes) do
        node:update(dt)
    end
end

return TestScene
