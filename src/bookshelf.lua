local BOOKSHELF = {}

local rectShelves = {
    {
        w = 400,
        h = wH/1.5,
        x = 600 ,
        y = wH - 200,
        rot = 9.5
    },
    {
        w = 400,
        h = wH/1.5,
        x = wW-200,
        y = wH - 200
    },
}

local hoverTarget = {
    x = wW/2 - 30,
    w = 60,

    y = 0,
    h = wH - 200
}

function BOOKSHELF:load()
    energyBar = {
        max = 20,
        fill = 0,
        rate = 2,
        decr = 4,
        decrT = 1
    }
end

function BOOKSHELF:update(dt)
end

function BOOKSHELF:draw()

    local rS = rectShelves
    lg.setColor(1,0,1)
    drawRectangle("fill", rS[1].x, rS[1].y, rS[1].w, rS[1].h, rS[1].w, rS[1].h, rS[1].rot)
    lg.setColor(1,1,0)    
    drawRectangle("fill", rS[2].x, rS[2].y, rS[2].w, rS[2].h, rS[2].w, rS[2].h, 0)



end

function BOOKSHELF:mousepressed(x, y, button)
    
end

function drawRectangle(mode, x, y, width, height, ox, oy, angle)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(math.rad(angle))
    love.graphics.rectangle(mode, -ox, -oy, width, height)
    love.graphics.pop()
end

return BOOKSHELF
