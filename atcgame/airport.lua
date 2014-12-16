local m = {}
m.__index = m

function m.create(extent, spawnpoints)
    local a = {}
    setmetatable(a, m)

    a.extent = extent
    a.spawns = spawnpoints

    return a
end

return m
