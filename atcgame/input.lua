local m = {}
m.__index = m

function m.create(coords, scene)
	local i = {}
	setmetatable(i, m)

	i.text = 'abc'
	i.coords = coords
	i.scene = scene
	return i
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

function m:backspace()
			self.text = string.sub(self.text,1,-2)
end

function m:draw()
    love.graphics.print(self.text, self.coords.x, self.coords.y)
end

return m
