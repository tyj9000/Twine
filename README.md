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

Copy the `Twine/` folder into your project and require Twine:

```lua
local Twine = require("Twine")
