---@class Signal
---@field id string
---@field subscribers function[]
---@field tags string[]

---@class Signals
local Signals = {
    ---@type table<string, Signal>
    events = {}
}

---@return Signal
---@param id string
---@param tags string[]?
function Signals:new(id, tags)
    if Signals.events[id] then
        return Signals.events[id]
    end

    Signals.events[id] = {
        id = id,
        subscribers = {},
        tags = tags or {}
    }

    return Signals.events[id]
end

function Signals:subscribe(id, callback)
    table.insert(Signals.events[id].subscribers, callback)
end

function Signals:emit(id, ...)
    for _, subscriber in ipairs(Signals.events[id].subscribers) do
        subscriber(...)
    end
end

function Signals:unsubscribe(id, callback)
    for i, subscriber in ipairs(Signals.events[id].subscribers) do
        if subscriber == callback then
            table.remove(Signals.events[id].subscribers, i)
            break
        end
    end
end

function Signals:clear(id)
    Signals.events[id].subscribers = {}
end

function Signals:clear_all()
    for id, _ in pairs(Signals.events) do
        Signals.events[id].subscribers = {}
    end
end

---@overload fun(tag: string)
---@overload fun(tags: string[], mode: 'all' | 'any')
function Signals:clear_with_tags(tag_or_tags, mode)
    for _, event in pairs(Signals.events) do
        local tags = event.tags
        if tags then
            if type(tag_or_tags) == "string" then
                for _, tag in ipairs(tags) do
                    if tag == tag_or_tags then
                        event.subscribers = {}
                        break
                    end
                end
            else
                if mode == "all" then
                    local all_tags = true
                    for _, tag in ipairs(tag_or_tags) do
                        local found = false
                        for _, event_tag in ipairs(tags) do
                            if tag == event_tag then
                                found = true
                                break
                            end
                        end
                        if not found then
                            all_tags = false
                            break
                        end
                    end
                    if all_tags then
                        event.subscribers = {}
                    end
                elseif mode == "any" then
                    for _, tag in ipairs(tag_or_tags) do
                        for _, event_tag in ipairs(tags) do
                            if tag == event_tag then
                                event.subscribers = {}
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

return Signals
