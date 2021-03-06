local m = {}
m.__index = m

function m.fromcoords(x, y, z)
    local p = {}
    setmetatable(p, m)

    if not z then
        z = 0
    end

    p.x = x
    p.y = y
    p.z = z

    return p
end

function m.frompoint(p0)
    return m.fromcoords(p0.x, p0.y, p0.z)
end

function m.fromdir(magnitude, direction)
    direction = math.rad(direction % 360)


    local x = math.sin(direction) * magnitude
    local y = math.cos(direction) * magnitude


    return m.fromcoords(x, y, 0)
end

function m:distance(p0)
    return math.sqrt((p0.x - self.x)^2 + (p0.y - self.y)^2)
end

function m:dir()
    return math.deg(math.atan2(self.x, self.y)) % 360
end

function m:translate(p0)
    return m.fromcoords(
    self.x + p0.x,
    self.y + p0.y,
    self.z + p0.z
    )
end

function m:vectorto(p0)
    return m.fromcoords(
    p0.x - self.x,
    p0.y - self.y,
    p0.y - self.z
    )
end


return m
