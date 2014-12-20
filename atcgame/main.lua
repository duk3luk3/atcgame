local pt = require "point"
local compass = require "compass"
local g = require "game"
local s = require "scene"
local i = require "input"


function love.load()

    love.window.setMode(0,0,{resizable=true})
    love.window.setTitle('ATC Game')

end

local scene = s.create(
pt.fromcoords(210, 5),
pt.fromcoords(love.graphics.getWidth()-215,love.graphics.getHeight()-43),
pt.fromcoords(20000,20000)
)
local game = g.create(scene)
local input = i.create(
pt.fromcoords(212, love.graphics.getHeight() - 20)
)

function love.update(dt)
    game:step(dt)
end

function love.textinput(t)
    input:update(t)
end

function love.keypressed(key, isrepeat)
    if key == 'return' then
        input:update('\n')
    end
end

function love.resize(w, h)
    scene:resize(
    pt.fromcoords(love.graphics.getWidth()-215, love.graphics.getHeight()-43))
    input.coords = pt.fromcoords(212, love.graphics.getHeight() - 20)
end

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.setColor(255,255,255)

    -- text box
    love.graphics.rectangle('line',5,5,200,height-216)

    -- compass box
    love.graphics.rectangle('line',5,height-206,200,200)

    local c = compass.create(pt.fromcoords(105, height-106), 70)
    c:draw()


    -- scene box
    love.graphics.rectangle('line',210,5,width-215,height-41)
    love.graphics.setColor(0,230,80)
    love.graphics.rectangle('fill',211,6,width-217,height-43)

    -- input box
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle('line',210,height-31,width-215,25)


    love.graphics.print("Hello World!", 10, 10)

    input:draw()
    scene:draw()


end
