local EscapeRs = {
    queued_draw_calls = {},
}

---@param draw_call fun()
function EscapeRs:queue_draw(draw_call)
    table.insert(self.queued_draw_calls, draw_call)
end

function EscapeRs:draw()
    for _, callback in ipairs(self.queued_draw_calls) do
        callback()
    end
    self.queued_draw_calls = {}
end

return EscapeRs
