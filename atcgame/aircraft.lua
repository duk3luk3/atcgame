local m = {}
m.__index = m

local p = require "point"
local q = require "queue"

function m.create(name, shortname, minspeed, maxspeed, cruisespeed)
    local c = {}
    setmetatable(c, m)
    c.name = name
    c.shortname = shortname
		c.callsign = 'AAA123'
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
        log = q.create(),
        target = nil
    }

    return c
end

function m:update(dt)
  -- process log
  if self.s.log[self.s.log.first] then
      local cmd = self.s.log[self.s.log.first]
      if cmd['type'] == 'fix' then
          local vector = p.fromcoords(
          cmd['coords'].x - self.s.pos.x,
          cmd['coords'].y - self.s.pos.y
          )
          self.s.set_heading = vector:dir()
      elseif cmd['type'] == 'heading' then
          self.s.set_heading = cmd['heading']
      end
      if cmd['altitude'] then
          self.s.set_altitude = cmd['altitude']
          if cmd['expedite'] then
              self.s.climb = 1000
          else
              self.s.climb = 500
          end
      end
  end
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

  local turn_dir = (self.s.set_heading - self.s.heading) % 360

  if turn_dir < 180 then
      if math.abs(self.s.heading - self.s.set_heading) > 5*dt then
          self.s.heading = (self.s.heading + 5*dt) % 360
      else
          self.s.heading = self.s.set_heading
      end
  elseif turn_dir >= 180 then
      if math.abs(self.s.heading - self.s.set_heading) > 5*dt then
          self.s.heading = (self.s.heading - 5*dt) % 360
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
  
    if self.s.log[self.s.log.first] then
      local cmd = self.s.log[self.s.log.first]

      love.graphics.print(cmd['name'], p.x + 5, p.y + 5)
      love.graphics.print(self.callsign, p.x + 5, p.y + 15)
    end
end


return m
