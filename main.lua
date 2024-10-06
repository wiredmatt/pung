require('global')
local Game = require('game')
local rs = require('lib.rs')
local baton = require('lib.baton')

rs.conf({
    game_width = VIRTUAL_WIDTH,
    game_height = VIRTUAL_HEIGHT,
    scale_mode = rs.STRETCH_MODE
})
rs.setMode(
    WINDOW_WIDTH, WINDOW_HEIGHT,
    {
        resizable = true,
        vsync = false,
        centered = true,
        minwidth = VIRTUAL_WIDTH,
        minheight = VIRTUAL_HEIGHT
    })

rs.resize_callback = function()
    Game.resize()
end

love.load = function()
    _G.input = baton.new {
        controls = {
            up = { 'key:up', 'key:w', 'axis:lefty-', 'button:dpup' },
            down = { 'key:down', 'key:s', 'axis:lefty+', 'button:dpdown' },
            restart = { 'key:r' }
        },
        pairs = {
            move = { 'up', 'down' }
        },
        joystick = love.joystick.getJoysticks()[1],
    }
    Game.load()
    rs.resize_callback()
end

love.update = function(dt)
    input:update()

    if input:pressed("restart") then
        Game.load()
    end

    Game.update(dt)
end

love.draw = function()
    gl.setColor(1, 1, 1, 1)
    rs.push()
    ---@format disable
        local old_x, old_y, old_w, old_h = gl.getScissor()
        gl.setScissor(rs.get_game_zone())
            Game.draw()
        gl.setScissor(old_x, old_y, old_w, old_h)
    ---@format enable
    rs.pop()
end

love.resize = function(w, h)
    rs.resize(w, h)
end
