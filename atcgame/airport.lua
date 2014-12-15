local m = {}
m.__index = m

function m.create(spawnpoints)
    local a = {}
    setmetatable(a, m)

    a.spawns = spawnpoints

    return a
end

return m
