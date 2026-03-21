local BOOKSHELF = {}
local notepadImg = lg.newImage("assets/screens/notepad-text.png")
mx, my = 0, 0

function BOOKSHELF:load()

end

function BOOKSHELF:update(dt)
    mx, my = love.mouse.getPosition()
end

function BOOKSHELF:draw()
    local function clamp(v, min, max)
    return math.max(min, math.min(max, v))
end

local function normalizeMouse(mx, my, cx, cy, w, h)
    local nx = (mx - cx) / (w / 2)
    local ny = (my - cy) / (h / 2)
    return clamp(nx, -1, 1), clamp(ny, -1, 1)
end

       local wW, wH = lg.getDimensions()
    local mx, my = love.mouse.getPosition()

    local cx = wW / 2
    local cy = wH / 2
    local iw = notepadImg:getWidth()
    local ih = notepadImg:getHeight()

    local nx, ny = normalizeMouse(mx, my, cx, cy, iw, ih)

    -- strength controls
    local tilt = 0.15
    local lift = 18

    local scaleX = 1 + nx * tilt
    local scaleY = 1 - ny * tilt

    local shearX = -nx * 0.25
    local shearY = -ny * 0.15

    local yLift = -math.abs(nx + ny) * lift

    lg.push()
    lg.translate(cx, cy + yLift)
    lg.shear(shearX, shearY)
    lg.scale(scaleX, scaleY)

    lg.draw(notepadImg, -iw / 2, -ih / 2)

    lg.pop()
end

return BOOKSHELF
