# Twine

![Twine Logo](./assets/logo.png)

Twine is a lightweight tweening and animation library for LÖVE (Love2D). It provides simple APIs for animating properties, handling easing, and managing animation lifecycles.

---

## Features

- Tween any table property (numbers, vectors, etc.)
- Built-in easing functions
- Signal-based events (`Started`, `Completed`, `StateChanged`)
- Support for rebounce/return animations

---

## Installation

>Copy the `Twine/` folder into your project and require Twine:

```lua
local Twine = require("Twine")
````

---

## Basic API

>Example with Twine
```lua
local Obj = {
    Color = {1,1,1}
}

function love.load()
    local tween = Twine.newTween(Obj, 2, "Linear", {Color = {1,0,0}}, true, {Color = {1,1,1}})

    tween.Started:Connect(function()
        print("Tween started!")
    end)

    tween.Completed:Connect(function()
        print("Tween finished!")
    end)

    tween:Play()
end

function love.update(dt)
    Twine.updateAll(dt)
end

function love.draw()
    love.graphics.setColor(Obj.Color)
    love.graphics.rectangle("fill", 100, 100, 200, 100) 
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Hello Twine!", 130, 140) 
    love.graphics.setFont(love.graphics.newFont(20))
end
```
