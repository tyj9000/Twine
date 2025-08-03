local Twine = require("Twine")

local uiElements = {}
for i = 1, 2000 do
    table.insert(uiElements, {
        x = math.random(0, 1000),
        y = math.random(0, 700),
        w = 20,
        h = 20,
        scale = 1
    })
end

local scaleTweens = nil

function love.load()
    love.graphics.setFont(love.graphics.newFont(14))
end

function love.draw()
    for _, ui in ipairs(uiElements) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.push()
        love.graphics.translate(ui.x + ui.w / 2, ui.y + ui.h / 2)
        love.graphics.scale(ui.scale, ui.scale)
        love.graphics.translate(-ui.w / 2, -ui.h / 2)
        love.graphics.rectangle("line", 0, 0, ui.w, ui.h)
        love.graphics.pop()
    end

    -- Draw button
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 20, 20, 150, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Scale All (Twine)", 30, 30)

    -- FPS
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 20, 70)
end

function love.mousepressed(x, y, button)
    if button == 1 and x >= 20 and x <= 170 and y >= 20 and y <= 60 then
        if scaleTweens then
            scaleTweens:Stop()
        end

        local tweens = {}
        for _, ui in ipairs(uiElements) do
            table.insert(tweens, Twine.newTween(ui, 0.5, "QuadOut", { scale = 1.2 }, true, { scale = 1 }))
        end

        scaleTweens = Twine.Bulk(tweens)
        scaleTweens:Play()

        scaleTweens.Completed:Connect(function()
            print("All scale tweens completed!")
        end)
    end
end

function love.update(dt)
    Twine.updateAll(dt)
end
