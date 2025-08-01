
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
