local m = {}
m.__index = m

local p = require "point"
local q = require "queue"

function m.create(name, shortname, minspeed, maxspeed, cruisespeed)
    local c = {}
    setmetatable(c, m)
    c.name = name
    c.shortname = shortname
    c.minspeed = minspeed
    c.maxspeed = maxspeed
    c.cruisespeed = cruisespeed
    c.s = {
        speed = cruisespeed,
        climb = 0,
        heading = 0,
        pos = p.fromcoords(0,0,7000),
        set_speed = cruisespeed,
        set_heading = 0,
        set_altitude = 7000,
        log = q.create()
    }

    return c
end

function m:update(dt)
  -- update rates
  if self.s.speed < self.s.set_speed then
      if self.s.speed + 10*dt < self.s.set_speed then
          self.s.speed = self.s.speed + 10*dt
      else
          self.s.speed = self.s.set_speed
      end
  elseif self.s.speed > self.s.set_speed then
      if self.s.speed - 10*dt > self.s.set_speed then
          self.s.speed = self.s.speed + 10*dt
      else
          self.s.speed = self.s.set_speeda
      end
  end
  
  -- update positions
  if self.s.pos.z < self.s.set_altitude then
      if self.s.pos.z + self.s.climb * dt < self.s.set_altitude then
          self.s.pos.z = self.s.pos.z + self.s.climb * dt
      else
          self.s.pos.z = self.s.set_altitude
          self.s.climb = 0
      end
  elseif self.s.pos.z > self.s.set_altitude then
      if self.s.pos.z - self.s.climb * dt > self.s.set_altitude then
          self.s.pos.z = self.s.pos.z - self.s.climb * dt
      else
          self.s.pos.z = self.s.set_altitude
          self.s.climb = 0
      end
  end

  if self.s.heading < self.s.set_heading then
      if self.s.heading + dt < self.s.set_heading then
          self.s.heading = self.s.heading + dt
      else
          self.s.heading = self.s.set_heading
      end
  elseif self.s.heading > self.s.set_heading then
      if self.s.heading - dt > self.s.set_heading then
          self.s.heading = self.s.heading - dt
      else
          self.s.heading = self.s.set_heading
      end
  end


  local vec = p.fromdir(self.s.speed * dt, self.s.heading)
  self.s.pos = self.s.pos:translate(vec)
end

function m:draw(scene)
    local p = scene:toscreen(self.s.pos)

    love.graphics.setColor(255,255,255,255)

    love.graphics.rectangle('fill', p.x - 2, p.y - 2, 5, 5)
end


return m
