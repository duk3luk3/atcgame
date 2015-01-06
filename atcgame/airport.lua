local m = {}
m.__index = m

local pt = require "point"

function m.create(extent, spawnpoints, runways)
    local a = {}
    setmetatable(a, m)

    a.extent = extent
    a.spawns = spawnpoints
		a.runways = runways

    return a
end

function m:draw(scene)
	for c = 1, self.runways:count() do
		local rwy = self.runways:get(c)
		local origin = scene:toscreen(rwy.coords)

		local forward = scene:toscreen(pt.fromdir(1000, rwy.dir):translate(rwy.coords))
		local backward = scene:toscreen(pt.fromdir(-1000, rwy.dir):translate(rwy.coords))

		love.graphics.setColor(255,255,255,255)
		love.graphics.line(backward.x, backward.y, forward.x, forward.y)
		love.graphics.print(rwy.name, origin.x + 10, origin.y + 10)


		
	end
end

return m
