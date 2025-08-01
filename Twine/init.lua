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

local Tween = require("Twine.tween") 

local activeTweens = {}

local Twine = {}


function Twine.newTween(target, time, easing, goalProps, rebounce, rval)
    local tween = Tween.new(target, time, easing, goalProps, rebounce, rval)
    table.insert(activeTweens, tween)
    return tween
end

function Twine.playAudio(audiofile)
    local audio = love.audio.newSource(audiofile, "static")
    audio:play()
end

function Twine.stopAudio(audiofile)
    local audio = love.audio.newSource(audiofile, "static")
    audio:stop()
end

function Twine._getActiveTweens()
    return activeTweens
end



function Twine.updateAll(dt)
    for i = #activeTweens, 1, -1 do
        local tween = activeTweens[i]
        tween:update(dt)
        if tween:Finished() then
            table.remove(activeTweens, i)
        end
    end
end


return Twine
