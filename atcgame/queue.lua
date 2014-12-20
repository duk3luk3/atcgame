local m = {}
m.__index = m

function m.create()
    local q = {}
    setmetatable(q, m)

    q.first = 0
    q.last = -1

    return q
end

function m:pushleft(value)
    local first = self.first - 1
    self.first = first
    self[first] = value
end

function m:pushright(value)
    local last = self.last + 1
    self.last = last
    self[last] = value
end

function m:popleft()
    local first = self.first
    if first > self.last then return nil end
    local value = self[first]
    self[first] = nil
    self.first = first + 1
    return value
end

function m:popright()
    local last = self.last
    if self.first > last then return nil end
    local value = self[last]
    self[last] = nil
    self.last = last - 1
    return value
end

return m
