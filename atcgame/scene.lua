local m = {}
m.__index = m

local arr = require "array"

function m.create(screen_top, screen_left, screen_w, screen_h,
    scene_w, scene_h)
    local s = {}
    setmetatable(s, m)

    s.screen_top = screen_top
    s.screen_left = screen_left
    s.screen_w = screen_w
    s.screen_h = screen_h
    s.scene_w = scene_w
    s.scene_h = scene_h

    s.objects = arr.create()

    s:rescale(screen_w, screen_h)

    return s
end

function m:rescale(screen_w, screen_h)
    self.screen_w = screen_w
    self.screen_h = screen_h

    local hscale = self.scene_h / self.screen_h
    local wscale = self.scene_w / self.screen_h

    self.scale = math.min(hscale, wscale)
end

function m:update(dt)
    for c = 1, self.objects:count() do
        if self.objects:get(c) and self.objects:get(c):update then
        self.objects:get(c):update(dt)
    end
end

function m:draw()
    love.graphics.translate(self.screen_left, self.screen_top)
    love.graphics.scale(self.scale, self.scale)

    for c = 1, self.objects:count() do
        if self.objects:get(c) then
            self.objects:get(c):draw()
        end
    end
end

return m
