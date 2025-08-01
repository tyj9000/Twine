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

local Twine = require("Twine") --Requite Twine

local Button = { 
    Position = {100, 100},
    Size = {200, 50},
    Scale = {1, 1},
    Text = "Click Me!",
    TextColor = {1, 1, 1},
    Hovered = false,
    Clicked = false,
} --Define a button

local onclick --Make onclick global

function love.load()
    --Create a tween for the button scale
    onclick = Twine.newTween(Button, 0.1, "Linear", {Scale = {1.1, 1.1}}, true, {Scale = {1, 1}})

    --Triggered when the tween state changes (running, paused, stopped)
    onclick.StateChanged:Connect(function(state)
        print("Animation state changed to: " .. state)
    end)
end

function love.update(dt)
    Twine.updateAll(dt)
    --Update all tweens
end

function love.draw()
    --Draw the button
    local w, h = Button.Size[1] * Button.Scale[1], Button.Size[2] * Button.Scale[2]
    local x, y = Button.Position[1], Button.Position[2]

    love.graphics.setColor(0.2, 0.6, 0.9)
    love.graphics.rectangle("fill", x, y, w, h)

    love.graphics.setColor(Button.TextColor)
    local font = love.graphics.getFont()
    local textW = font:getWidth(Button.Text)
    local textH = font:getHeight()
    love.graphics.print(Button.Text, x + (w - textW) / 2, y + (h - textH) / 2)

    love.graphics.setColor(1, 1, 1)
end

function love.mousepressed(mx, my, button)
    if button == 1 then
        local x, y = Button.Position[1], Button.Position[2]
        local w, h = Button.Size[1] * Button.Scale[1], Button.Size[2] * Button.Scale[2]

        if mx >= x and mx <= x + w and my >= y and my <= y + h then
            print("You clicked!")
            if onclick:getState() == "stopped" then --Get the current state of the tween
                onclick:Play() --Play the tween
            end
        end
    end
end
