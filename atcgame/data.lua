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
            spawns:set(1, {
                ['name'] = 'A',
                ['coords'] = pt.fromcoords(-9000,-9000)
            })
            spawns:set(2, {
                ['name'] = 'B',
                ['coords'] = pt.fromcoords(-9000,0)
            })
            spawns:set(3, {
                ['name'] = 'C',
                ['coords'] = pt.fromcoords(-9000,9000)
            })
            spawns:set(4, {
                ['name'] = 'D',
                ['coords'] = pt.fromcoords(9000,-9000)
            })
            spawns:set(5, {
                ['name'] = 'E',
                ['coords'] = pt.fromcoords(9000,0)
            })
            spawns:set(6, {
                ['name'] = 'F',
                ['coords'] = pt.fromcoords(9000,9000)
            })
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

    local craft = crafts[love.math.random(1,count)]()

    local spawn = port.spawns:get(love.math.random(1,port.spawns:count()))
    local target = port.spawns:get(love.math.random(1,port.spawns:count()))

    local vector = spawn['coords']:vectorto(pt.fromcoords(0,0)):dir()

    craft.s.heading = vector
    craft.s.pos.x = spawn['coords'].x
    craft.s.pos.y = spawn['coords'].y
    craft.s.pos = craft.s.pos:translate(pt.fromdir(50,vector))
    craft.s.log:pushleft({
        ['type'] = 'fix',
        ['coords'] = target['coords'],
        ['name'] = target['name']
    })
    craft.s.target = target
    craft.callsign = 'UAL'..love.math.random(1,9)..love.math.random(1,9)..love.math.random(1,9)

    return craft
end

return m
