---@class Signal
---@field id string
---@field subscribers function[]

---@class Signals
local Signals = {}

---@return Signal
function Signals:new(id)
    table.insert(Signals, {
        id = id,
        subscribers = {}
    })

    return Signals[#Signals]
end

function Signals:subscribe(id, callback)
    for _, signal in ipairs(Signals) do
        if signal.id == id then
            table.insert(signal.subscribers, callback)
        end
    end
end

function Signals:emit(id, ...)
    for _, signal in ipairs(Signals) do
        if signal.id == id then
            for _, subscriber in ipairs(signal.subscribers) do
                subscriber(...)
            end
        end
    end
end

function Signals:unsubscribe(id, callback)
    for _, signal in ipairs(Signals) do
        if signal.id == id then
            for i, subscriber in ipairs(signal.subscribers) do
                if subscriber == callback then
                    table.remove(signal.subscribers, i)
                end
            end
        end
    end
end

function Signals:clear(id)
    for _, signal in ipairs(Signals) do
        if signal.id == id then
            signal.subscribers = {}
        end
    end
end

return Signals
