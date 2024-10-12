local Signals = require "lib.signals"

---@class WithPhysicsCallbacks
local WithPhysicsCallbacks = {
    ---@param self GameObjectWithMaybePhysicsCallbacks
    register_physics_callbacks = function(self, _begin, _end)
        if self.fixture == nil then
            print("No fixture for " .. self.id)
            return
        end

        self.fixture:setUserData(self.id)

        local signals = {
            begin_contact = Signals:new(self.id .. "_begin_contact"),
            end_contact = Signals:new(self.id .. "_end_contact")
        }

        local callbacks = {
            begin_contact = self[_begin] or self.begin_contact,
            end_contact = self[_end] or self.end_contact
        }

        for key, signal in pairs(signals) do
            local callback = callbacks[key]
            if callback ~= nil then
                Signals:subscribe(signal.id, function(a, b, coll)
                    callback(self, a, b, coll)
                end)
            end
        end
    end
}

return WithPhysicsCallbacks
