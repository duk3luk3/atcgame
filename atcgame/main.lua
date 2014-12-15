local point = require "point"
local compass = require "compass"
local g = require "game"


function love.load()

    love.window.setMode(0,0,{resizable=true})
    love.window.setTitle('ATC Game')

end

local angle = 0
local game = g.create()

function love.update(dt)
    angle = (angle + dt * 25) % 360

    game:step(dt)
end

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.setColor(255,255,255)

    -- text box
    love.graphics.rectangle('line',5,5,200,height-216)

    -- compass box
    love.graphics.rectangle('line',5,height-206,200,200)

    local c = compass.create(point.fromcoords(105, height-106), 70)
    c:draw()


    love.graphics.rectangle('line',210,5,width-215,height-11)
    love.graphics.setColor(0,230,80)
    love.graphics.rectangle('fill',211,6,width-217,height-13)

    love.graphics.setColor(255,255,255)
    love.graphics.print("Hello World!", 10, 10)

    love.graphics.circle('line', 800, 500, 300, 100)

    local v = point.fromdir(250, angle)
    love.graphics.print(""..v.x..", "..v.y, 10, 25)

    v = v:translate(point.fromcoords(800, 500))

    love.graphics.line(800, 500, v.x, v.y)

    for c = 1, game.craft:count() do
        local craft = game.craft:get(c)
        craft:draw()
    end

end
