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


local Easing = {}

-- Linear
function Easing.Linear(t)
    return t
end

-- Quadratic
function Easing.Quad(t)
    return t * t
end

function Easing.OutQuad(t)
    return t * (2 - t)
end

function Easing.InOutQuad(t)
    if t < 0.5 then
        return 2 * t * t
    else
        return -1 + (4 - 2 * t) * t
    end
end

-- Cubic
function Easing.Cubic(t)
    return t * t * t
end

function Easing.OutCubic(t)
    t = t - 1
    return t * t * t + 1
end

function Easing.InOutCubic(t)
    if t < 0.5 then
        return 4 * t * t * t
    else
        t = t - 1
        return (t * t * t * 4 + 1)
    end
end

-- Quartic
function Easing.Quart(t)
    return t * t * t * t
end

function Easing.OutQuart(t)
    t = t - 1
    return 1 - t * t * t * t
end

function Easing.InOutQuart(t)
    if t < 0.5 then
        return 8 * t * t * t * t
    else
        t = t - 1
        return 1 - 8 * t * t * t * t
    end
end

-- Quintic
function Easing.Quint(t)
    return t * t * t * t * t
end

function Easing.OutQuint(t)
    t = t - 1
    return 1 + t * t * t * t * t
end

function Easing.InOutQuint(t)
    if t < 0.5 then
        return 16 * t * t * t * t * t
    else
        t = t - 1
        return 1 + 16 * t * t * t * t * t
    end
end

-- Sine
function Easing.Sine(t)
    return 1 - math.cos((t * math.pi) / 2)
end

function Easing.OutSine(t)
    return math.sin((t * math.pi) / 2)
end

function Easing.InOutSine(t)
    return -(math.cos(math.pi * t) - 1) / 2
end

-- Exponential
function Easing.Expo(t)
    return (t == 0) and 0 or math.pow(2, 10 * (t - 1))
end

function Easing.OutExpo(t)
    return (t == 1) and 1 or 1 - math.pow(2, -10 * t)
end

function Easing.InOutExpo(t)
    if t == 0 then return 0 end
    if t == 1 then return 1 end
    if t < 0.5 then
        return math.pow(2, 20 * t - 10) / 2
    else
        return (2 - math.pow(2, -20 * t + 10)) / 2
    end
end

-- Back
function Easing.Back(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    return c3 * t * t * t - c1 * t * t
end

function Easing.OutBack(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    t = t - 1
    return 1 + c3 * t * t * t + c1 * t * t
end

function Easing.InOutBack(t)
    local c1 = 1.70158
    local c2 = c1 * 1.525
    if t < 0.5 then
        return (math.pow(2 * t, 2) * ((c2 + 1) * 2 * t - c2)) / 2
    else
        return (math.pow(2 * t - 2, 2) * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
    end
end

-- Elastic
function Easing.Elastic(t)
    if t == 0 or t == 1 then return t end
    return -math.pow(2, 10 * (t - 1)) * math.sin((t - 1.075) * (2 * math.pi) / 0.3)
end

function Easing.OutElastic(t)
    if t == 0 or t == 1 then return t end
    return math.pow(2, -10 * t) * math.sin((t - 0.075) * (2 * math.pi) / 0.3) + 1
end

function Easing.InOutElastic(t)
    if t == 0 or t == 1 then return t end
    t = t * 2
    if t < 1 then
        return -0.5 * math.pow(2, 10 * (t - 1)) * math.sin((t - 1.1125) * (2 * math.pi) / 0.45)
    else
        return math.pow(2, -10 * (t - 1)) * math.sin((t - 1.1125) * (2 * math.pi) / 0.45) * 0.5 + 1
    end
end

-- Bounce
function Easing.OutBounce(t)
    local n1 = 7.5625
    local d1 = 2.75
    if t < 1 / d1 then
        return n1 * t * t
    elseif t < 2 / d1 then
        t = t - 1.5 / d1
        return n1 * t * t + 0.75
    elseif t < 2.5 / d1 then
        t = t - 2.25 / d1
        return n1 * t * t + 0.9375
    else
        t = t - 2.625 / d1
        return n1 * t * t + 0.984375
    end
end

function Easing.Bounce(t)
    return 1 - Easing.OutBounce(1 - t)
end

function Easing.InOutBounce(t)
    if t < 0.5 then
        return (1 - Easing.OutBounce(1 - 2 * t)) / 2
    else
        return (1 + Easing.OutBounce(2 * t - 1)) / 2
    end
end

return Easing
