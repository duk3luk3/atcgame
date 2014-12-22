local m = {}
m.__index = m

local a = require "aircraft"
local v = require "vor"
local d = require "data"
local arr = require "array"
local que = require "queue"

function m.create(scene)
    local g = {}
    setmetatable(g, m)

    g.scene = scene
    g.craft = arr.create()
    g.craft_by_cs = {}
    g.fixes = {}
    g.selected = nil
    g.airport = d.airports()[1]()
    g.laststep = 0
    g.drawstep = 0
    g.time = 0

    for c = 1, g.airport.spawns:count() do
      local spawn = g.airport.spawns:get(c)
      g.scene.objects:add(v.create(spawn['coords'], spawn['name']))
      g.fixes[spawn['name']] = spawn
    end

    return g
end

function m:command(t)

  local words = string.gmatch(t, '%w+')

  local cs = words()

  if self.craft_by_cs[cs] then
    local craft = self.craft_by_cs[cs]
    local appending = false
    while true do
      local cmd = words()
      if not cmd then
        break
      end
      if cmd == 'next' then
        appending = true
      elseif cmd == 'fix' then
        local point = words()
        if self.fixes[point] then
          local fix = self.fixes[point]
          if not appending then
            craft.s.log = que.create()
            appending = true
          end
          craft.s.log:pushright({
            ['type'] = 'fix',
            ['coords'] = fix['coords'],
            ['name'] = fix['name']
          })
        else
          print('Did not understand fix ('..point..')')
          break
        end

      end

    end
  end

  if self.craft_by_cs[cs] then
    if self.selected then
      self.selected.selected = false
    end
    self.craft_by_cs[cs].selected = true
    self.selected = self.craft_by_cs[cs]
    print('selected: '..self.craft_by_cs[cs].callsign)
  end
end

function m:step(dx)
    local t = self.time + dx

    if t > self.laststep + 2 then
      if love.math.random() > 0.7 then
        local craft = d.aircraft(self.airport)
        self.craft:add(craft)
        self.scene.objects:add(craft)
        self.craft_by_cs[craft.callsign] = craft
        print('Created '..craft.callsign)
      end
      self.laststep = t
    end

    for c = 1, self.craft:count() do
      local e = self.craft:get(c)

      if e then

        -- check for destination reached
        if e.s.target and e.s.pos.z >= 4000 and
           e.s.pos:distance(e.s.target.coords) < 50 and
           math.abs(e.s.pos:vectorto(e.s.target.coords):dir() - e.s.heading) < 30 then
          self.craft:set(c, nil)
          e.alive = false
        else
          e:update(dx)

        end
      end
    end

    self.time = t
end

return m
