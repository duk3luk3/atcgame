local m = {}
m.__index = m

local a = require "aircraft"
local d = require "data"
local arr = require "array"

function m.create()
    local g = {}
    setmetatable(g, m)

    g.craft = arr.create()
    g.airport = d.airports()[1]()
    g.laststep = 0
    g.drawstep = 0
    g.time = 0

    return g
end

function m:step(dx)
    local t = self.time + dx

    if t > self.laststep + 2 then
        if love.math.random() > 0.7 then
            self.craft:add(d.aircraft(self.airport))
        end
        self.laststep = t
    end

    for c = 1, self.craft:count() do
        local e = self.craft:get(c)
        e:update(dx)

    end

    self.time = t
end

return m
