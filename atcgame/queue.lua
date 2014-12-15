local m = {}
m.__index = m

function m.create()
    local q = {}
    setmetatable(q, m)

    q.list = {
        first = 0,
        last = -1
    }

    return q
end

function m:pushleft(value)
    local first = self.list.first - 1
    self.list.first = first
    self.list[first] = value
end

function m:pushright(value)
    local last = self.list.last + 1
    self.list.last = last
    self.list[last] = value
end

function m:popleft()
    local first = self.list.first
    if first > self.list.last then return nil end
    local value = self.list[first]
    self.list[first] = nil
    self.list.first = first + 1
    return value
end

function m:popright()
    local last = self.list.last
    if self.list.first > last then return nil end
    local value = self.list[last]
    self.list[last] = nil
    self.list.last = last - 1
    return value
end

return m
