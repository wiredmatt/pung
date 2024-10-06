local Object = require "lib.object"

---@class Bg : Object
local Bg = Object:extend()

---@param img_path string
---@param x number
---@param y number
function Bg:new(img_path, x, y, target_w, target_h)
    self.image = gl.newImage(img_path)

    self.x, self.y = x or 0, y or 0

    self.width, self.height = self.image:getWidth(), self.image:getHeight()

    self.target_w, self.target_h = target_w or VIRTUAL_WIDTH, target_h or VIRTUAL_HEIGHT

    self.sx, self.sy = self.target_w / self.width, self.target_h / self.height
end

function Bg:draw()
    gl.draw(self.image, self.x, self.y, 0, self.sx, self.sy)
end

return Bg
