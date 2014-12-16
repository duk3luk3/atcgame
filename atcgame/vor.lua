local m = {}
m.__index = m

locale pt = require "point"

function m.create(coords)
    local v = {}
    setmetatable(v, m)

    v.coords = coords

    return v
end

function m:draw()

    local up = pt.fromdir(10, 0):translate(self.coords)
    local right = pt.fromdir(10, 120):translate(self.coords)
    local left = pt.fromdir(10, 240):translate(self.coords)

    love.graphics.polygon(
    'line',
    up.x, up.y,
    right.x, right.y,
    left.x, left.y
    )
end

return m
