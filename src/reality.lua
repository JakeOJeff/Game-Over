local REALITY = {}
realitynav = nav:new(REALITY, "TELEPHONE")
local bg = lg.newImage("assets/screens/bg.png")

function REALITY:load()
    folder:load()
end

function REALITY:update(dt)
    update_notes(dt)
    update_knots(dt)
    realitynav:update(dt)
    folder:update(dt)
end

function REALITY:draw()
    lg.draw(bg, 0, 0)
    folder:drawBack()
    draw_notes()
    draw_knots()
    folder:drawFront()
    realitynav:draw()
end

function REALITY:mousepressed(x, y, button)
    mousedown_notes(x, y, button)
    mousedown_knots(x, y, button)
end

function REALITY:mousereleased(x, y, button)
    mouserelease_notes(button)
end

return REALITY
