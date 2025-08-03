local Tween = require("Twine.tween") 
local Bulk = require("Twine.bulk")

local activeTweens = {}
local activeSeqBulks = {}

local Twine = {}

function Twine.newTween(target, time, easing, goalProps, rebounce, rval)
    local tween = Tween.new(target, time, easing, goalProps, rebounce, rval)
    table.insert(activeTweens, tween)
    return tween
end

function Twine.Bulk(tweens)
    return Bulk.new(tweens)
end

function Twine.SeqBulk(gap, tweens)
    local group = Bulk.Seq(gap, tweens)
    table.insert(activeSeqBulks, group)
    return group
end

function Twine._getActiveTweens()
    return activeTweens
end

function Twine.updateAll(dt)
    -- update tweens
    for i = #activeTweens, 1, -1 do
        local tween = activeTweens[i]
        tween:update(dt)
        if tween:Finished() then
            table.remove(activeTweens, i)
        end
    end

    -- update seq bulks
    for i = #activeSeqBulks, 1, -1 do
        local seq = activeSeqBulks[i]
        seq:update(dt)
        if seq:Finished() then
            table.remove(activeSeqBulks, i)
        end
    end
end

return Twine
