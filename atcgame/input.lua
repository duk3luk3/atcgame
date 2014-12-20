local m = {}
m.__index = m

function m.create(coords)
    m.text = 'abc'
    m.coords = coords
    return m
end

function m:update(t)
    if t == '\n' then
        t = self.text
        self.text = ''
        return t
    else
        self.text = self.text .. t
        return nil
    end
end

function m:draw()
    love.graphics.print(self.text, self.coords.x, self.coords.y)
end

return m
