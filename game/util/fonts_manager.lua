---@enum (key) FontNames
local default_fonts = { teko = "teko" }

local FontsManager = {
    _default_fonts = default_fonts,
    -- example:
    -- FontsManager.fonts.teko = {
    --     regular = {
    --         small = gl.newFont("assets/fonts/teko/teko_regular.ttf", 8)
    --     }
    -- }
    ---@type table<string, table<string, table<string, love.Font>>>
    fonts = {}
}

local base_path = "assets/fonts"

---@enum (key) FontStyles
local styles = { regular = "regular", light = "light", medium = "medium", bold = "bold", semibold = "semibold" }
---@enum (key) FontSizes
local sizes = { small = 8, medium = 16, large = 32 }

local function get_font_path(font_name, style)
    return base_path .. "/" .. font_name .. "/" .. font_name .. "_" .. style .. ".ttf"
end

local function get_font(font_name, style, size)
    return gl.newFont(get_font_path(font_name, style), size)
end

function FontsManager:load_defaults()
    self.fonts.default = gl.getFont()

    for _, font_name in ipairs(self._default_fonts) do
        self.fonts[font_name] = {}

        for _, style in ipairs(styles) do
            self.fonts[font_name][style] = {}

            for size_name, size in pairs(sizes) do
                self.fonts[font_name][style][size_name] = get_font(font_name, style, size)
            end
        end
    end
end

function FontsManager:use_custom(font_name, font_style, font_size)
    if self.fonts[font_name] and self.fonts[font_name][font_style] and self.fonts[font_name][font_style][font_size] then
        local f = self.fonts[font_name][font_style][font_size]
        gl.setFont(f)
    else
        local f = get_font(font_name, font_style, font_size)
        self.fonts[font_name] = self.fonts[font_name] or {}
        self.fonts[font_name][font_style] = self.fonts[font_name][font_style] or {}
        self.fonts[font_name][font_style][font_size] = f
        gl.setFont(f)
    end
end

---@param font_name FontNames
---@param font_style FontStyles
---@param font_size FontSizes
function FontsManager:set(font_name, font_style, font_size)
    local f = self.fonts[font_name][font_style][font_size]
    gl.setFont(f)
end

function FontsManager:unset()
    gl.setFont(self.fonts.default)
end

return FontsManager
