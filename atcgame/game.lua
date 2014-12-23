local m = {}
m.__index = m

local a = require "aircraft"
local v = require "vor"
local d = require "data"
local l = require "list"
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

  local list = l.create()

  for c in words do
    list:add(c)
  end

  local craft = self.craft_by_cs[list.first.value]

  if craft then
    if self.selected then
      self.selected.selected = false
    end
    craft.selected = true
    self.selected = craft
    print('selected: '..craft.callsign)
  end

  if craft then
    local appending = false
    local cur = list.first.next
    local command = {}

    while true do
      if cur then
        print("Parsing: "..cur.value)
      end
      if not cur or not cur.next then
        if command['altitude'] or command['speed'] or command['type'] then
          if not appending then
            craft.s.log = que.create()
          end
          craft.s.log:pushright(command)
        else
          print('Incomplete command')
        end
        break
      elseif string.lower(cur.value) == 'next' then
        if command['altitude'] or command['speed'] or command['type'] then
          if not appending then
            craft.s.log = que.create()
          end
          craft.s.log:pushright(command)
        end
        appending = true
        command = {}
      elseif string.lower(cur.value) == 'fix' then
        if command['type'] then
          print("Conflicting command")
          break
        end
        if not cur.next then
          print("Incomplete command")
          break
        end
        local name = string.upper(cur.next.value)
        local fix = self.fixes[name]
        if not fix then
          print("No such fix "..name)
        end
        command['type'] = 'fix'
        command['coords'] = fix['coords']
        command['name'] = fix['name']

        -- gobble fix name
        cur = cur.next
      elseif string.lower(cur.value) == 'climb' then
        if command['altitude'] then
          print("Conflicting command")
          break
        end
        if not cur.next then
          print("Incomplete command")
          break
        end
        local alt = cur.next.value
        if string.len(alt) <= 2 then
          alt = tonumber(alt) * 1000
        else
          alt = tonumber(alt)
        end

        if not alt then
          print("Could not parse altitude")
          break
        end
        if alt < 1000 then
          print("altitude too low")
          break
        end
        command['altitude'] = alt
        --gobble altitude
        cur = cur.next
      elseif string.lower(cur.value) == 'speed' then
        if command['speed'] then
          print("Conflicting command")
          break
        end
        if not cur.next then
          print("Incomplete command")
          break
        end

        local speed = tonumber(cur.next.value)
        if not speed then
          print("Could not parse speed")
          break
        end
        if speed < craft.minspeed then
          speed = craft.minspeed
        elseif speed > craft.maxspeed then
          speed = craft.maxspeed
        end
        command['speed'] = speed
        -- gobble speed
        cur = cur.next
      elseif string.lower(cur.value) == 'for' then
        if command['for'] then
          print("Conflicting command")
          break
        end
        if not cur.next then
          print("Incomplete command")
          break
        end

        local dist = tonumber(cur.next.value)
        if not dist then
          print("Could not parse distance")
        end

        command['for'] = dist * 1852

        --gobble dist
        cur = cur.next
      end

      cur = cur.next
    end
  end

end

function m:step(dx)
    local t = self.time + dx

    if t > self.laststep + 3 then
      if love.math.random() > 0.8 or self.craft:count() < 3  then
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
