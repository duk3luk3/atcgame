local m = {}
m.__index = m

local arr = require "array"
local pt = require "point"

function m.create(screen_tl, screen_wh, scene_wh)
    local s = {}
    setmetatable(s, m)

    s.objects = arr.create()
    
    s.screen_tl = screen_tl
    s.screen_wh = screen_wh
    s.scene_wh = scene_wh

    s.scale = math.max(
    screen_wh.x / scene_wh.x,
    screen_wh.y / scene_wh.y
    )

    return s
end

function m:resize(screen_wh)
    self.screen_wh = screen_wh
    self.scale = math.min(
    self.screen_wh.x / self.scene_wh.x,
    self.screen_wh.y / self.scene_wh.y
    )
end

function m:toscreen(p0)
    p = pt.fromcoords(p0.x,p0.y)
    p.x = p.x + self.scene_wh.x / 2
    p.y = p.y + self.scene_wh.y / 2
    -- scale
    p.x = p.x * self.scale
    p.y = p.y * self.scale
    -- flip y
    p.y = self.screen_wh.y - p.y
    -- move to center
    -- p.x = p.x + self.screen_wh.x / 2
    -- p.y = p.y + self.screen_wh.y / 2

    return p
end

function m:update(dt)
    for c = 1, self.objects:count() do
        if self.objects:get(c) and self.objects:get(c):update then
        self.objects:get(c):update(dt)
    end
end

function m:draw()
    -- draw frame
    --
    local xx = self.scene_wh.x / 2.05
    local xy = self.scene_wh.y / 2.05
    local tl = self:toscreen(pt.fromcoords(-xx, xy))
    local tr = self:toscreen(pt.fromcoords( xx, xy))
    local br = self:toscreen(pt.fromcoords( xx, -xy))
    local bl = self:toscreen(pt.fromcoords(-xx, -xy))
    love.graphics.polygon(
    'line',
    tl.x, tl.y,
    tr.x, tr.y,
    br.x, br.y,
    bl.x, bl.y
    )

    local a = self:toscreen(pt.fromcoords(-10,10))
    local b = self:toscreen(pt.fromcoords(0,10))
    local c = self:toscreen(pt.fromcoords(-10,0))
    love.graphics.polygon(
    'line',
    a.x, a.y,
    b.x, b.y,
    c.x, c.y
    )

    for c = 1, self.objects:count() do
        self.objects:get(c):draw(self)
    end

end

return m
