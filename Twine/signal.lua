local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({ _handlers = {} }, Signal)
end

function Signal:Connect(fn)
    local conn = { fn = fn, disconnected = false }
    table.insert(self._handlers, conn)

    conn.index = #self._handlers
    function conn:Disconnect()
        if not self.disconnected then
            self.disconnected = true
            self._handlers[self.index] = nil
        end
    end

    return conn
end

function Signal:Fire(...)
    for i, conn in ipairs(self._handlers) do
        if conn and not conn.disconnected and conn.fn then
            conn.fn(...)
        end
    end
end

function Signal:DisconnectAll()
    for i = 1, #self._handlers do
        self._handlers[i] = nil
    end
end

function Signal:Destroy()
    self:DisconnectAll()
end

return Signal
