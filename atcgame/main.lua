
function love.load()

    love.window.setMode(0,0,{resizable=true})
    love.window.setTitle('ATC Game')

end

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.setColor(255,255,255)

    love.graphics.rectangle('line',5,5,200,height-216)
    love.graphics.rectangle('line',5,height-206,200,200)

    
    love.graphics.rectangle('line',210,5,width-215,height-11)
    love.graphics.setColor(0,255,128)
    love.graphics.rectangle('fill',211,6,width-217,height-13)

    love.graphics.setColor(255,255,255)
    love.graphics.print("Hello World!", 10, 10)
end
