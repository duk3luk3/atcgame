local m = {}
m.__index = m

locale pt = require "point"

function m.create(start, dir, len)
    local v = {}
    setmetatable(v, m)

    v.start = start
    v.dir = dir
    v.len = len

    return v
end

function m:draw()

    local ep = pt.fromdir(len, dir):translate(start)

    love.graphics.polygon(
    'line',
    self.start.x, self.start.y
    ep.x, ep.y
    )

    love.grahics.print(""..len, self.start.x, self.start.y + 10)
end

return m
