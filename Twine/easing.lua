local Easing = {}
local pi = math.pi
local sin, cos = math.cos, math.sin
local pow = math.pow

-- Linear
function Easing.Linear(t) return t end

-- Quadratic
function Easing.Quad(t) return t * t end
function Easing.OutQuad(t) return t * (2 - t) end
function Easing.InOutQuad(t)
    local double = t * 2
    return double < 1 and 0.5 * double * double or -0.5 * ((double - 1) * (double - 3) - 1)
end

-- Cubic
function Easing.Cubic(t) return t * t * t end
function Easing.OutCubic(t)
    t = t - 1
    return t * t * t + 1
end
function Easing.InOutCubic(t)
    return t < 0.5 and 4 * t^3 or (t - 1)^3 * 4 + 1
end

-- Quartic
function Easing.Quart(t) return t^4 end
function Easing.OutQuart(t)
    t = t - 1
    return 1 - t^4
end
function Easing.InOutQuart(t)
    return t < 0.5 and 8 * t^4 or 1 - 8 * (t - 1)^4
end

-- Quintic
function Easing.Quint(t) return t^5 end
function Easing.OutQuint(t)
    t = t - 1
    return 1 + t^5
end
function Easing.InOutQuint(t)
    return t < 0.5 and 16 * t^5 or 1 + 16 * (t - 1)^5
end

-- Sine
function Easing.Sine(t) return 1 - cos(t * pi / 2) end
function Easing.OutSine(t) return sin(t * pi / 2) end
function Easing.InOutSine(t) return -(cos(pi * t) - 1) / 2 end

-- Exponential (softer base)
function Easing.Expo(t)
    return t == 0 and 0 or pow(2, 8 * (t - 1))
end
function Easing.OutExpo(t)
    return t == 1 and 1 or 1 - pow(2, -8 * t)
end
function Easing.InOutExpo(t)
    if t == 0 then return 0 end
    if t == 1 then return 1 end
    local double = t * 2
    return double < 1 and pow(2, 8 * (double - 1)) / 2
        or (2 - pow(2, -8 * (double - 1))) / 2
end

-- Back (softer & smoother)
local c1 = 1.70158
local c2 = c1 * 1.525

function Easing.Back(t)
    return (c1 + 1) * t^3 - c1 * t^2
end
function Easing.OutBack(t)
    t = t - 1
    return 1 + (c1 + 1) * t^3 + c1 * t^2
end
function Easing.InOutBack(t)
    local double = t * 2
    if double < 1 then
        return 0.5 * (double^2 * ((c2 + 1) * double - c2))
    else
        double = double - 2
        return 0.5 * (double^2 * ((c2 + 1) * double + c2) + 2)
    end
end

-- Elastic (tighter curve, smoother phase)
function Easing.Elastic(t)
    if t == 0 or t == 1 then return t end
    return -pow(2, 8 * (t - 1)) * sin((t - 1.05) * (2 * pi) / 0.4)
end
function Easing.OutElastic(t)
    if t == 0 or t == 1 then return t end
    return pow(2, -8 * t) * sin((t - 0.05) * (2 * pi) / 0.4) + 1
end
function Easing.InOutElastic(t)
    if t == 0 or t == 1 then return t end
    t = t * 2
    local s = (t - 1.05) * (2 * pi) / 0.45
    return t < 1
        and -0.5 * pow(2, 8 * (t - 1)) * sin(s)
        or 0.5 * pow(2, -8 * (t - 1)) * sin(s) + 1
end

-- Bounce (optional softer bounce)
local n1, d1 = 6.75, 2.75
function Easing.OutBounce(t)
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
    return t < 0.5
        and (1 - Easing.OutBounce(1 - 2 * t)) / 2
        or (1 + Easing.OutBounce(2 * t - 1)) / 2
end

return Easing
