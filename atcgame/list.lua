local m = {}
m.__index = m

function m.create()
    local l = {}
    setmetatable(l,m)

    l.first = nil
    l.last = nil

    return l
end

function m:add(value)
    local item = {}
    item.value = value
    item.next = nil
    item.prev = self.last

    if not self.first then
        self.first = item
    end

    if self.last then
        self.last.next = item
    end
    self.last = item
end

function m:remove(item)
    if self.first == item then
        self.first = item.next
    end
    if self.last == item then
        self.last = item.prev
    end
    item.prev.next = item.next
    if item.next then
        item.next.prev = item.prev
    end
end


return m
