local m = {}
m.__index = m

function m.fromcoords(x, y, z)
    local p = {}
    setmetatable(p, m)

    p.x = x
    p.y = y
    p.z = z

    return p
end

function m.frompoint(p0)
    return m.fromcoords(p0.x, p0.y, p0.z)
end

return m
