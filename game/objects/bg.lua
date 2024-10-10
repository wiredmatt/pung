local GameObject = require "game.objects.game_object"

---@class Bg : GameObject
---@field super GameObject
---@field new fun(self, img_path: string, x?: number, y?: number, target_w?: number, target_h?: number): Bg
local Bg = Class('Bg', GameObject)

---@param img_path string
---@param x number
---@param y number
function Bg:initialize(img_path, x, y, target_w, target_h)
    GameObject.initialize(self)

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
