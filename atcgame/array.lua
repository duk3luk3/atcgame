local m = {}
m.__index = m

function m.create()
    a = {}
    setmetatable(a, m)

    a.list = {}
    a.index = 1

    return a
end

function m:get(index)
    return self.list[index]
end

function m:set(index, value)
    self.list[index] = value
    if index == self.index then
        self.index = self.index + 1
    end
end

function m:add(value)
    self:set(self.index, value)
end

function m:count()
    return self.index - 1
end

return m
