local Player       = require "game.objects.player"
local Ai           = require "game.objects.ai"
local Ball         = require "game.objects.ball"
local Wall         = require "game.objects.wall"
local Bg           = require "game.objects.bg"
local FontsManager = require "game.util.fonts_manager"
local ERS          = require "game.util.escape_rs"
local Signals      = require "lib.signals"
local EVENTS       = require "game.constant.events"

local Gameplay     = {
    ---@type GameObject[]
    objects = {},
    ---@type love.World
    physics_world = nil
}

function Gameplay:load()
    gl.setDefaultFilter('nearest', 'nearest')
    self.objects = {}
    self.physics_world = physics.newWorld(0, 0, true)

    table.insert(self.objects, Bg:new("assets/sprites/board.png"))

    local ball = Ball:new({ 1, 1, 1, 1 }, self.physics_world)
    table.insert(self.objects, ball)

    table.insert(self.objects, Player(
        (Player.width), (VIRTUAL_HEIGHT / 2),
        1, 1,
        self.physics_world
    ))

    table.insert(self.objects, Ai(
        ball,
        VIRTUAL_WIDTH - (Ai.width), (VIRTUAL_HEIGHT / 2),
        -1, 1,
        self.physics_world
    ))

    table.insert(self.objects, Wall(VIRTUAL_WIDTH / 2, -5, VIRTUAL_WIDTH, 10, self.physics_world))
    table.insert(self.objects, Wall(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT + 5, VIRTUAL_WIDTH, 10, self.physics_world))

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

    Signals:emit(EVENTS.LAUNCH_BALL)
end

function Gameplay:draw()
    for _, object in ipairs(self.objects) do
        object:draw()
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

function Gameplay:update(dt)
    self.physics_world:update(dt)
    for _, object in ipairs(self.objects) do
        object:update(dt)
    end
end

return Gameplay
