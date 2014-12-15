local point = require "point"

local m = {}
m.__index = m

function m.create(origin, radius)
    local c = {}
    setmetatable(c,m)

    c.origin = origin
    c.radius = radius
    c.wind = 0

    return c
end

function m:text(dir, text)
    local foff = point.fromdir(self.radius + 15, dir)
    foff.y = - foff.y
    foff = foff:translate(self.origin)
    love.graphics.printf(text, foff.x-20, foff.y-4, 40, 'center')
end

function m:drawwind(dir)
    local foff = point.fromdir(self.radius - 15, dir)
    foff.y = - foff.y
    foff = foff:translate(self.origin)
    love.graphics.circle('fill', foff.x, foff.y, 10, 10)
end

function m:draw()

    love.graphics.circle('line', self.origin.x, self.origin.y, self.radius,
    50)

    self:text(0, "000")
    self:text(90, "090")
    self:text(180, "180")
    self:text(270, "270")
    self:text(0+45, "045")
    self:text(90+45, "135")
    self:text(180+45, "225")
    self:text(270+45, "315")

    self:drawwind(self.wind)

end

return m
