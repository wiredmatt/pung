local Signals              = require "lib.singals"

---@class GameObjectWithMaybePhysicsCallbacks : GameObjectWithPhysics
---@field begin_contact function?
---@field end_contact function?
---@field register_physics_callbacks fun(self, _begin: function?, _end: function?)

---@class WithPhysicsCallbacks
local WithPhysicsCallbacks = {
    ---@param self GameObjectWithMaybePhysicsCallbacks
    register_physics_callbacks = function(self, _begin, _end)
        if self.fixture == nil then
            print("No fixture for " .. self.id)
            return
        end

        self.fixture:setUserData(self.id)

        local signal_begin_contact = Signals:new(self.id .. "_begin_contact")
        local signal_end_contact = Signals:new(self.id .. "_end_contact")

        _begin = _begin or self.begin_contact

        _end = _end or self.end_contact

        Signals:subscribe(signal_begin_contact.id, function(a, b, coll)
            if _begin ~= nil then
                _begin(self, a, b, coll)
            end
        end)
        Signals:subscribe(signal_end_contact.id, function(a, b, coll)
            if _end ~= nil then
                _end(self, a, b, coll)
            end
        end)
    end
}

return WithPhysicsCallbacks
