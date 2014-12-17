local m = {}
m.__index = m

local pt = require "point"

function m.create(coords)
    local v = {}
    setmetatable(v, m)

    v.coords = coords

    return v
end

function m:draw(scene)
    local origin = scene:toscreen(self.coords)

    local up = pt.fromdir(10, 0):translate(origin)
    local right = pt.fromdir(10, 120):translate(origin)
    local left = pt.fromdir(10, 240):translate(origin)

    love.graphics.setColor(255,255,255,255)

    love.graphics.polygon(
    'line',
    up.x, up.y,
    right.x, right.y,
    left.x, left.y
    )
end

return m
