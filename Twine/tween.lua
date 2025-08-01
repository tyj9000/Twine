--[[
MIT License

Copyright (c) 2025 tyj9000

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--


local Easing = require("Twine.easing")
local Signal = require("Twine.signal")

local Tween = {}
Tween.__index = Tween

local activeTweens = {}

function Tween.new(target, duration, easingName, goal, shouldReturn, returnValue)
    if activeTweens[target] then
        activeTweens[target].canceled = true
    end

    local self = setmetatable({}, Tween)
    self.target = target
    self.duration = duration
    self.elapsed = 0
    self.easing = Easing[easingName] or Easing.Linear
    self.goal = goal
    self.start = {}
    self.shouldReturn = shouldReturn or false
    self.returnValue = returnValue or {}
    self.returning = false
    self.canceled = false
    self.running = false

    -- Events
    self.Started = Signal.new()
    self.Completed = Signal.new()
    self.StateChanged = Signal.new()

    for k, v in pairs(goal) do
        self.start[k] = Tween.copy(target[k])
    end

    return self
end

function Tween:Play()
    if not self.running then
        self.elapsed = 0
        self.running = true
        self.canceled = false
        self.returning = false
        self.Started:Fire()
        self.StateChanged:Fire("running") -- 🔥

        local list = require("Twine")._getActiveTweens()
        if not self._listed then
            table.insert(list, self)
            self._listed = true
        end
    end
end

function Tween:Pause()
    if self.running and not self.canceled then
        self.running = false
        self._paused = true
        self.StateChanged:Fire("paused") -- 🔥
    end
end

function Tween:Resume()
    if self._paused and not self.canceled then
        self.running = true
        self._paused = false
        self.StateChanged:Fire("running") -- 🔥
    end
end

function Tween:Stop()
    self.canceled = true
    self.running = false
    self._listed = false
    self.StateChanged:Fire("stopped") -- 🔥
end


function Tween:getState()
    if self.canceled then
        return "stopped"
    elseif self._paused then
        return "paused"
    elseif self.running then
        return "running"
    else
        return "stopped"
    end
end



function Tween.copy(value)
    if type(value) == "table" then
        local out = {}
        for i, v in ipairs(value) do
            out[i] = v
        end
        return out
    else
        return value
    end
end

function Tween:lerp(a, b, t)
    if type(a) == "table" then
        local result = {}
        for i = 1, #a do
            result[i] = a[i] + (b[i] - a[i]) * t
        end
        return result
    else
        return a + (b - a) * t
    end
end

function Tween:update(dt)
    if not self.running or self.canceled then return end

    self.elapsed = math.min(self.elapsed + dt, self.duration)
    local t = self.easing(self.elapsed / self.duration)

    local from = self.returning and self.goal or self.start
    local to = self.returning and (next(self.returnValue) and self.returnValue or self.start) or self.goal

    for k, _ in pairs(self.goal) do
        self.target[k] = self:lerp(from[k], to[k], t)
    end

    if self.elapsed >= self.duration then
        if self.shouldReturn and not self.returning then
            self.returning = true
            self.elapsed = 0
        else
            self:Stop()
            self.Completed:Fire()
        end
    end
end

function Tween:Finished()
    return not self.running
end

function Tween.cancelAllFor(target)
    if activeTweens[target] then
        activeTweens[target].canceled = true
        activeTweens[target] = nil
    end
end

return Tween
