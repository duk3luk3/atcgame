local m = {}
m.__index = m

local pt = require "point"

function m.create(coords, name)
    local v = {}
    setmetatable(v, m)

    v.coords = coords
    v.name = name

    return v
end

function m:draw(scene)
    local origin = scene:toscreen(self.coords)

    local up = pt.fromdir(10, 180):translate(origin)
    local right = pt.fromdir(10, 300):translate(origin)
    local left = pt.fromdir(10, 60):translate(origin)

    love.graphics.setColor(255,255,255,255)

    love.graphics.polygon(
    'line',
    up.x, up.y,
    right.x, right.y,
    left.x, left.y
    )

    if self.name then
        love.graphics.print(self.name, up.x + 10, up.y)
    end
end

return m
