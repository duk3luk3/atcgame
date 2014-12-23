local m = {}
m.__index = m

local p = require "point"
local q = require "queue"
local tr = require "trace"

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
    c.traces = q.create()
    c.traces.ts = 0.2

    return c
end

function m:update(dt)
  -- update traces
  for c = self.traces.first, self.traces.last do
    local trace = self.traces[c]
    if trace.time >= trace.expiry then
      trace.alive = false
      self.traces:popleft()
    else
      trace.time = trace.time + dt
    end
  end

  self.traces.ts = self.traces.ts - dt
  if self.traces.ts <= 0 then
    local trace = tr.create(self.s.pos, 5)
    self.traces:pushright(trace)

    self.traces.ts = self.traces.ts + 0.2
  end

  -- check log
  if self.s.log[self.s.log.first] then
    local cmd = self.s.log[self.s.log.first]
    if
      (cmd['for'] and cmd['for'] <= 0) or
      (cmd['type'] == 'fix' and self.s.pos:distance(cmd['coords']) < 50)
    then
      self.s.log:popleft()
    end
  end

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
      if cmd['speed'] then
        self.s.set_speed = cmd['speed']
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

  if self.s.log[self.s.log.first] then
    local cmd = self.s.log[self.s.log.first]
    if cmd['for'] then
      cmd['for'] = cmd['for'] - self.s.speed * dt
    end
  end
end

function m:draw(scene)
    local p = scene:toscreen(self.s.pos)


    love.graphics.setColor(255,255,255,255)

    for c = self.traces.first, self.traces.last do
      self.traces[c]:draw(scene)
    end

    if self.selected then
      love.graphics.setColor(255,0,0,255)
    end

    love.graphics.rectangle('fill', p.x - 2, p.y - 2, 5, 5)
    love.graphics.setColor(0,255,255,255)
    love.graphics.print(self.callsign, p.x + 5, p.y + 5)

    if self.s.log[self.s.log.first] then
      local cmd = self.s.log[self.s.log.first]
      love.graphics.print(
      string.format("HDG %3.f (%s)", self.s.heading, cmd['name'] or string.format("%03d", cmd['heading'] or self.s.set_heading)),
      p.x + 5, p.y + 17)

      if cmd['for'] then
        love.graphics.print(
        cmd['for'],
        p.x+5, p.y+53
        )
      end
    else
      love.graphics.print(
      string.format("HDG %3.f (%3.f)", self.s.heading, self.s.set_heading),
      p.x + 5, p.y + 17)
    end


    love.graphics.print(
    string.format("SPD %.f (%.f)", self.s.speed, self.s.set_speed),
    p.x + 5, p.y + 29)
    love.graphics.print(
    string.format("ALT %.f (%.f)", self.s.pos.z, self.s.set_altitude),
    p.x + 5, p.y + 41)

    if self.s.target then
      love.graphics.print(self.s.target['name'], p.x + 5, p.y - 15)
    end
end


return m
