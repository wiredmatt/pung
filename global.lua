_G.gl = love.graphics
_G.window = love.window
_G.physics = love.physics

for _, v in ipairs(arg) do
    if v == "-debug" then
        _G.debug_physics = require("lib.debug_physics")
        print("Debug mode enabled")
    end
end

_G.PX_MT = 30 -- 1 meter = 30 pixels
_G.VIRTUAL_WIDTH, _G.VIRTUAL_HEIGHT = 640, 360

_G.WINDOW_WIDTH, _G.WINDOW_HEIGHT = window.getDesktopDimensions() --[[@as number]]
_G.WINDOW_WIDTH, _G.WINDOW_HEIGHT = WINDOW_WIDTH / 1.5, WINDOW_HEIGHT / 1.5

---@generic T
---@param o T
---@param seen any?
---@return T
function _G.copy(o, seen)
    seen = seen or {}
    if o == nil then return nil end
    if seen[o] then return seen[o] end

    local no
    if type(o) == 'table' then
        no = {}
        seen[o] = no

        for k, v in next, o, nil do
            no[copy(k, seen)] = copy(v, seen)
        end
        setmetatable(no, copy(getmetatable(o), seen))
    else -- number, string, boolean, etc
        no = o
    end
    return no
end

Class = require("lib.class")
