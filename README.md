# <img src="./assets/logo.png" alt="Twine Logo" width="80"/> 



Twine is a lightweight tweening and animation library for LÖVE (Love2D). It provides simple APIs for animating properties, handling easing, and managing animation lifecycles inspired by Roblox's event-driven TweenService.

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
---

## API Reference
>Parameters
```lua
local Tween = Twine.newTween(target, duration, easing, goal, shouldReturn, returnValue)
````
**Params**

+ **target:** Table to animate (e.g., {Scale = {1,1}})
+ **duration:** Time in seconds
+ **easing:** Easing function name ("Linear", "InQuad", etc.)
+ **goal:** Table of properties to tween
+ **shouldReturn:** (optional) If true, returns to start after reaching goal
+ **returnValue:** (optional) Table of values to return to

---
**Methods**

+ **:Play()--** Start the tween
+ **:Pause()--** Pause the tween
+ **:Resume()--** Resume the tween
+ **:Stop()--** Cancel the tween
+ **:getState()--** Returns "running", "paused", or "stopped"
+ **:Finished()--** Returns true if stopped

**Bulk (Group Tween)**
---
+ **.Bulk({tweens})--** Creates a bulk with tweens in table, same methods apply.
---
**Signals**

+ **Started--** Fires when tween starts
+ **Completed--** Fires when tween ends
+ **StateChanged--**  Fires on state change ("running", "paused", "stopped")

---
## Updating
>Updating tweens via dt
```lua
function love.update(dt)
    Twine.updateAll(dt)
end
````

---

MIT License Copyright (c) 2025 tyj9000 
  




