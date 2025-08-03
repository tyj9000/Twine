local Signal = require("Twine.signal")

local Bulk = {}
Bulk.__index = Bulk

-- === Constructor: Parallel bulk ===
function Bulk.new(tweens)
    local self = setmetatable({}, Bulk)
    self.tweens = tweens or {}
    self.mode = "parallel"
    self._running = false
    self._queuedFinishCheck = false

    self.Completed = Signal.new()
    self.StateChanged = Signal.new()
    self.SignalChanged = Signal.new()

    for _, tween in ipairs(self.tweens) do
        tween.StateChanged:Connect(function(state)
            self.SignalChanged:Fire(tween, state)
        end)
        tween.Completed:Connect(function()
            self._queuedFinishCheck = true
        end)
    end

    return self
end

-- === Constructor: Sequential bulk ===
function Bulk.Seq(gapTime, tweens)
    local self = setmetatable({}, Bulk)
    self.tweens = tweens or {}
    self.gapTime = gapTime or 0
    self.index = 1
    self.timer = 0
    self.mode = "sequential"
    self._playing = false
    self._waiting = false

    self.Completed = Signal.new()
    self.StateChanged = Signal.new()
    self.SignalChanged = Signal.new()

    for _, tween in ipairs(self.tweens) do
        tween.StateChanged:Connect(function(state)
            self.SignalChanged:Fire(tween, state)
        end)
    end

    return self
end

-- === Shared ===
function Bulk:allFinished()
    for _, tween in ipairs(self.tweens) do
        if not tween:Finished() then
            return false
        end
    end
    return true
end

function Bulk:Play()
    self.StateChanged:Fire("running")

    if self.mode == "parallel" then
        self._running = true
        for _, tween in ipairs(self.tweens) do
            tween:Play()
        end

    elseif self.mode == "sequential" then
        self._playing = true
        self._waiting = false
        self.index = 1
        self.timer = 0
        if self.tweens[1] then
            self.tweens[1]:Play()
        end
    end
end

function Bulk:Pause()
    self.StateChanged:Fire("paused")
    if self.mode == "parallel" then
        for _, tween in ipairs(self.tweens) do
            tween:Pause()
        end
    elseif self.mode == "sequential" then
        self._playing = false
        if self.tweens[self.index] then
            self.tweens[self.index]:Pause()
        end
    end
end

function Bulk:Resume()
    self.StateChanged:Fire("running")
    if self.mode == "parallel" then
        for _, tween in ipairs(self.tweens) do
            tween:Resume()
        end
    elseif self.mode == "sequential" then
        self._playing = true
        if self.tweens[self.index] then
            self.tweens[self.index]:Resume()
        end
    end
end

function Bulk:Stop()
    self.StateChanged:Fire("stopped")
    self:_cleanupSignals()

    if self.mode == "parallel" then
        self._running = false
    elseif self.mode == "sequential" then
        self._playing = false
    end

    for _, tween in ipairs(self.tweens) do
        tween:Stop()
    end
end

function Bulk:_cleanupSignals()
    self.Completed:DisconnectAll()
    self.StateChanged:DisconnectAll()
    self.SignalChanged:DisconnectAll()
end

function Bulk:Finished()
    return self.mode == "parallel" and self:allFinished()
        or (not self._playing and self.index > #self.tweens)
end

function Bulk:update(dt)
    if self._queuedFinishCheck then
        self._queuedFinishCheck = false
        if self:allFinished() then
            self._running = false
            self.Completed:Fire()
            self.StateChanged:Fire("completed")
        end
    end

    if self.mode ~= "sequential" or not self._playing then return end

    local current = self.tweens[self.index]
    if current and current:Finished() then
        self.index = self.index + 1
        if self.index <= #self.tweens then
            self._waiting = true
            self.timer = 0
        else
            self._playing = false
            self.Completed:Fire()
            self.StateChanged:Fire("completed")
        end
    end

    if self._waiting then
        self.timer = self.timer + dt
        if self.timer >= self.gapTime then
            self._waiting = false
            self.tweens[self.index]:Play()
        end
    end
end

return Bulk
