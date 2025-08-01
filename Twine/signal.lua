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

local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({ _handlers = {} }, Signal)
end

function Signal:Connect(fn)
    table.insert(self._handlers, fn)
    return {
        Disconnect = function()
            for i, v in ipairs(self._handlers) do
                if v == fn then
                    table.remove(self._handlers, i)
                    break
                end
            end
        end
    }
end

function Signal:Fire(...)
    for _, fn in ipairs(self._handlers) do
        fn(...)
    end
end

function Signal:Destroy()
    self._handlers = {}
end

return Signal
