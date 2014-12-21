local m = {}
m.__index = m

local q = require "queue"

function m.create(coords, game)
  local i = {}
  setmetatable(i, m)

  i.text = ''
  i.buffer = q.create()
  i.bufferpos = i.buffer.last
  i.coords = coords
  i.game = game
  return i
end

function m:update(t)
    if t == '\n' then
      t = self.text
      self.text = ''

      self.buffer:pushright(t)
      if self.buffer.last - self.buffer.first > 128 then
        self.buffer:popleft()
      end
      self.bufferpos = self.buffer.last

      self.game:command(t)

    else
        self.text = self.text .. t
        self.buffer[self.buffer.last] = self.text
        self.bufferpos = self.buffer.last

        return nil
    end
end

function m:up()
  if self.buffer[self.bufferpos-1] then
    self.text = self.buffer[self.bufferpos-1]
    self.bufferpos = self.bufferpos -1
  end
end

function m:down()
  if self.buffer[self.bufferpos+1] then
    self.text = self.buffer[self.bufferpos+1]
    self.bufferpos = self.bufferpos + 1
  else
    self.text = ''
  end
end

function m:backspace()
      self.text = string.sub(self.text,1,-2)
end

function m:draw()
    love.graphics.print(self.text, self.coords.x, self.coords.y)
end

return m
