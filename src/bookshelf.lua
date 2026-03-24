local BOOKSHELF = {}
local text = "Move Shelf"

local rectRot = 36
local rectShelves = {
    {
        w = 400,
        h = wH / 1.5,
        x = 500,
        y = wH - 150,
        rot = rectRot
    },
    {
        w = 400,
        h = wH / 1.5,
        x = wW - 100,
        y = wH - 150
    },
}

local panellingDef = {
    x = wW / 2,
    y = wH - 400
}
local panelling = {
    w = 200,
    h = 200,
    x = panellingDef.x,
    y = panellingDef.y
}
local rectState = "STUCK"  -- Stuck/Falling/Fallen
local panelState = "STUCK" -- Stuck/Pulling/Pulled

local hoverTarget = {
    x = wW / 2 - 30,
    w = 60,

    y = 0,
    h = wH - 200,

    hovering = false
}

local clickCircles = {}
local pointLines = {
    {
        x = 0,
        y = 0,
    },
    {
        x = 0,
        y = 0,
    },
}

local particles = {}

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

    if panelState == "PULLING" then
        pointLines[2].x, pointLines[2].y = mx, my
    end

    for i = #particles, 1, -1 do
        local v = particles[i]
            v.x = v.x + v.vx * dt
            v.y = v.y + v.vy * dt
            v.life = v.life - dt

        if v.life <= 0 then
            table.remove(particles, i)
        end
    end

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

    if panelState == "FAILED" then
        if panelling.y < panellingDef.y + 30 then
            panelling.y = math.min(panellingDef.y + 30, panelling.y + 60 * dt)
        else
            panelState = "STUCK"
        end
    elseif panelState == "STUCK" then
        if panelling.y > panellingDef.y then
            panelling.y = math.max(panellingDef.y, panelling.y - 60 * dt)
        end
    elseif panelState == "PULLED" then
        if panelling.y < panellingDef.y + 245 then
            panelling.y = math.min(panellingDef.y + 300, panelling.y + (panelling.y / (panellingDef.y + 245)) * 600 * dt)
        end
    end


    if energyBar.fill >= energyBar.max and rectShelves[1].rot > 0 then
        rectState = "FALLING"

        rectShelves[1].rot = math.max(0, rectShelves[1].rot - 10 * ((rectRot / 3 / rectShelves[1].rot)) * dt)
        if rectShelves[1].rot <= 0 then
            rectState = "FALLEN"

            createFlatParticles(200, 6, rectShelves[1].x - rectShelves[1].w, rectShelves[1].y, rectShelves[1].w, -1)

            hoverTarget = {
                x = panelling.x - panelling.w / 2,
                y = panelling.y - panelling.h,
                w = panelling.w,
                h = panelling.h,
                hovering = false
            }
            text = "Pull Panel"
        end
    elseif energyBar.fill < energyBar.max then
        rectShelves[1].rot = rectRot - (rectRot / 3) * energyBar.fill / energyBar.max
    end

    print(collectgarbage("collect"))
end

function BOOKSHELF:draw()
    local rS = rectShelves
    lg.setColor(0, 0, 1)
    drawRectangle("line", panellingDef.x, panellingDef.y, panelling.w, panelling.h, panelling.w / 2, panelling.h, 0)

    drawRectangle("fill", panelling.x, panelling.y, panelling.w, panelling.h, panelling.w / 2, panelling.h, 0)
    lg.setColor(1, 0, 1)
    drawRectangle("fill", rS[1].x, rS[1].y, rS[1].w, rS[1].h, rS[1].w, rS[1].h, rS[1].rot)
    lg.setColor(1, 1, 0)
    drawRectangle("fill", rS[2].x, rS[2].y, rS[2].w, rS[2].h, rS[2].w, rS[2].h, 0)


    for i, v in ipairs(particles) do
        lg.setColor(1, 1, 1, 0.5 * v.life/v.maxLife)
        lg.circle("fill", v.x, v.y, 10 * (v.life/v.maxLife))
    end

    lg.setColor(1, 1, 1)
    for i, v in ipairs(clickCircles) do
        if v.rad >= 1 then
            lg.circle("line", v.x, v.y, v.rad)
        end
    end

    if panelState == "PULLING" then
        lg.setColor(1, 1, 1)
        lg.circle("line", pointLines[1].x, pointLines[1].y, 2)
        lg.circle("line", pointLines[2].x, pointLines[2].y, 2)
        lg.line(pointLines[1].x, pointLines[1].y, pointLines[2].x, pointLines[2].y)
    end


    if hoverTarget.hovering then
        if rectState ~= "FALLING" then
            lg.setFont(fontM)
            lg.print(text, mx - fontM:getWidth(text) / 2, my + 20)
        end

        if rectState == "STUCK" then
            lg.rectangle("fill", mx - fontM:getWidth(text) / 2, my + 20 + fontM:getHeight(), fontM:getWidth(text), 20)
            lg.setColor(0, 0, 1)
            lg.rectangle("fill", mx - fontM:getWidth(text) / 2, my + 20 + fontM:getHeight(),
                fontM:getWidth(text) * energyBar.fill / energyBar.max, 20)
        end
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

        if rectState == "FALLEN" then
            panelState = "PULLING"
            pointLines[1].x, pointLines[1].y = x, y
        end
    end
end

function BOOKSHELF:mousereleased(x, y, button)
    if panelState == "PULLING" then
        if pointLines[2].y - pointLines[1].y > 200 and math.abs(pointLines[2].x - pointLines[1].x) < 50 then
            panelState = "PULLED"
            text = "Inspect"
        else
            panelState = "FAILED"
        end
    end
end

function drawRectangle(mode, x, y, width, height, ox, oy, angle)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(math.rad(angle))
    love.graphics.rectangle(mode, -ox, -oy, width, height)
    love.graphics.pop()
end

function createFlatParticles(amt, life, x, y, width, dir)
    for i = 1, amt do
            table.insert(particles, {
                x = love.math.random(x, x + width),
                y = y + love.math.random(-10, 5),
                dir = dir,
                life = life,
                maxLife = life,
                vx = love.math.random(-10, 10),
                vy = love.math.random(-24, -10)
            })
    end
end

return BOOKSHELF
