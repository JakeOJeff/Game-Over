local BOOKSHELF = {}

local rectShelves = {
    {
        w = 400,
        h = wH / 1.5,
        x = 600,
        y = wH - 200,
        rot = 9.5
    },
    {
        w = 400,
        h = wH / 1.5,
        x = wW - 200,
        y = wH - 200
    },
}

local hoverTarget = {
    x = wW / 2 - 30,
    w = 60,

    y = 0,
    h = wH - 200,

    hovering = false
}

local clickCircles = {}
local mx, my = 0, 0
function BOOKSHELF:load()
    energyBar = {
        max = 20,
        fill = 0,
        rate = 5,
        decr = 0.15,
    }
end

function BOOKSHELF:update(dt)
    mx, my = love.mouse.getPosition()

    if mx > hoverTarget.x and mx < hoverTarget.x + hoverTarget.w and my > hoverTarget.y and my < hoverTarget.y + hoverTarget.h then
        hoverTarget.hovering = true
    else
        hoverTarget.hovering = false
    end

    for i, v in ipairs(clickCircles) do
        v.t = math.max(0, v.t - dt)
        v.rad = v.t / 1 * v.rad
        if v.t <= 0 then table.remove(clickCircles, i) end
    end

    if energyBar.fill ~= 0 and energyBar.fill < energyBar.max then
        energyBar.fill = math.max(0, energyBar.fill - energyBar.decr)
    end

    if energyBar.fill >= energyBar.max then
        rectShelves[1].rot = math.max(0, rectShelves[1].rot - 10 * ((9.5/3/rectShelves[1].rot)) * dt)
    else
            rectShelves[1].rot =  9.5 - (9.5/3) * energyBar.fill/energyBar.max
    end
end

function BOOKSHELF:draw()
    local rS = rectShelves
    lg.setColor(1, 0, 1)
    drawRectangle("fill", rS[1].x, rS[1].y, rS[1].w, rS[1].h, rS[1].w, rS[1].h, rS[1].rot)
    lg.setColor(1, 1, 0)
    drawRectangle("fill", rS[2].x, rS[2].y, rS[2].w, rS[2].h, rS[2].w, rS[2].h, 0)

    lg.setColor(1, 1, 1)
    for i, v in ipairs(clickCircles) do
        if v.rad >= 1 then
            lg.circle("line", v.x, v.y, v.rad)
        end
    end


    if hoverTarget.hovering then
        lg.setFont(fontM)
        local text = "Move Shelf" 
        lg.print(text, mx - fontM:getWidth(text)/2, my + 20)
        lg.rectangle("fill", mx - fontM:getWidth(text)/2, my + 20 + fontM:getHeight(), fontM:getWidth(text), 20)
        lg.setColor(0,0,1)
        lg.rectangle("fill", mx - fontM:getWidth(text)/2, my + 20 + fontM:getHeight(), fontM:getWidth(text) * energyBar.fill/energyBar.max, 20)
    end
    
end

function BOOKSHELF:mousepressed(x, y, button)
    if hoverTarget.hovering and button == 1 then
        table.insert(clickCircles, {
            x = x,
            y = y,
            rad = 30,
            t = 1
        })

        energyBar.fill = math.min(energyBar.max, energyBar.fill + energyBar.rate)
    end
end

function drawRectangle(mode, x, y, width, height, ox, oy, angle)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(math.rad(angle))
    love.graphics.rectangle(mode, -ox, -oy, width, height)
    love.graphics.pop()
end

return BOOKSHELF
