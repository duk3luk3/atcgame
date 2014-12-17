local m = {}
m.__index = m

local pt = require "point"

function m.create(coords, expiry)
    local t = {}
    setmetatable(t, m)

    t.coords = coords
    t.time = 0
    t.expiry = expiry
    t.alive = true

    return t
end

function m:update(dt)
    self.time = self.time + dt

end

function m:draw(scene)

    if self.time < self.expiry then
        local origin = scene:toscreen(self.coords)

        love.graphics.setColor(255,255,255,255 * (self.expiry - self.time) / self.expiry )

        love.graphics.rectangle(
        'fill',
        origin.x - 1, origin.y - 1, 3, 3
        )
    end
end

return m
