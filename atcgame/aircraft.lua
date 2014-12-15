local m = {}
m.__index = m

local p = require "point"

function m.create(name, shortname, minspeed, maxspeed, cruisespeed)
    local c = {}
    setmetatable(c, m)
    c.name = name
    c.shortname = shortname
    c.minspeed = minspeed
    c.maxspeed = maxspeed
    c.cruisespeed = cruisespeed
    c.state = {
        speed = cruisespeed,
        climb = 0,
        heading = 0,
        altitude = 7000,
        pos = p.create(0,0,7000),
        set_speed = cruisespeed,
        set_heading = 0,
        set_altitude = 7000,
        log = {}
    }

    return c
end

function m:update(dt)
  -- update rates
  if self.state.speed < self.state.set_speed then
      if self.state.speed + 10*dt < self.state.set_speed then
          self.state.speed = self.state.speed + 10*dt
      else
          self.state.speed = self.state.set_speed
      end
  else if self.state.speed > self.state.set_speed then
      if self.state.speed - 10*dt > self.state.set_speed then
          self.state.speed = self.state.speed + 10*dt
      else
          self.state.speed = self.state.set_speed
  end
  
  -- update positions
  if self.state.altitude < self.state.set_altitude then
      if self.state.altitude + self.state.climb * dt < self.state.set_altitude then
          self.state.altitude = self.state.altitude + self.state.climb * dt
      else
          self.state.altitude = self.state.set_altitude
          self.state.climb = 0
      end
  else if self.state.altitude > self.state.set_altitude then
      if self.state.altitude - self.state.climb * dt > self.state.set_altitude then
          self.state.altitude = self.state.altitude - self.state.climb * dt
      else
          self.state.altitude = self.state.set_altitude
          self.state.climb = 0
      end
  end

  


end


return m
