local m = {}
m.__index = m

local a = require "aircraft"
local p = require "airport"
local arr = require "array"
local pt = require "point"

function m.airports()
    local ports = {
        [1] = function()
            local spawns = arr.create()
            spawns:set(1, pt.fromcoords(-9000,-9000))
            spawns:set(2, pt.fromcoords(-9000,0))
            spawns:set(3, pt.fromcoords(9000,100))
            local extent = pt.fromcoords(10000, 10000)
            return p.create(extent, spawns)
            end
    }
    return ports
end

function m.aircraft(port)
    local crafts = {
        [1] = function()
            return a.create("Cessna Skymaster", "CM337",
            170, 100, 125)
        end,
        [2] = function()
            return a.create("Boeing 747", "B747",
            180, 500, 240)
        end
    }
    local count = 2

    craft = crafts[love.math.random(1,count)]()

    spawn = port.spawns:get(love.math.random(1,port.spawns:count()))

    craft.s.heading = 090
    craft.s.pos.x = spawn.x
    craft.s.pos.y = spawn.y

    return craft
end

return m
