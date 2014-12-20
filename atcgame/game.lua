local m = {}
m.__index = m

local a = require "aircraft"
local v = require "vor"
local d = require "data"
local tr = require "trace"
local arr = require "array"
local que = require "queue"

function m.create(scene)
    local g = {}
    setmetatable(g, m)

    g.scene = scene
    g.craft = arr.create()
    g.traces = que.create()
    g.airport = d.airports()[1]()
    g.laststep = 0
    g.drawstep = 0
    g.lasttrace = 0
    g.time = 0

    for c = 1, g.airport.spawns:count() do
        local spawn = g.airport.spawns:get(c)
        g.scene.objects:add(v.create(spawn['coords'], spawn['name']))
    end

    return g
end

function m:step(dx)
    local t = self.time + dx

    if t > self.laststep + 2 then
        if love.math.random() > 0.7 then
            local craft = d.aircraft(self.airport)
            self.craft:add(craft)
            self.scene.objects:add(craft)
        end
        self.laststep = t
    end

    local trace_hit = t > self.lasttrace + 0.2

    for c = 1, self.craft:count() do
        local e = self.craft:get(c)
        e:update(dx)

        if trace_hit then
            local trace = tr.create(e.s.pos, 5)
            self.traces:pushright(trace)
            self.scene.objects:add(trace)
        end
    end
    if trace_hit then
        self.lasttrace = t
    end

    for c = self.traces.first, self.traces.last do
        local trace = self.traces[c]
        if trace.time >= trace.expiry then
            trace.alive = false
            self.traces:popleft()
        else
            trace.time = trace.time + dx
        end
    end

    self.time = t
end

return m
