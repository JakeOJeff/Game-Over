local OVERVIEW = {}

function OVERVIEW:load()
    TableTarget = {
        x = 0,
        y = 0,
        w = wW,
        h = 200
    }
    tableImg = lg.newImage("assets/screens/tablesoon.png")
    text = "The game so far contains incredible concepts and easter eggs upto this point. Tinker around to find out each one of them! Press R to restart and view the experience from the beginning"
end

function OVERVIEW:update(dt)
    
end

function OVERVIEW:draw()
    -- lg.setColor(1,0,1)
    -- lg.rectangle("fill", TableTarget.x, TableTarget.y, TableTarget.w, TableTarget.h - 40)
    --     lg.setColor(1,0,1, 0.5)

    -- lg.rectangle("fill", TableTarget.x, TableTarget.y + TableTarget.h - 40, TableTarget.w, 40)
    
    lg.draw(tableImg)
    lg.setFont(fontS)
    lg.printf(text, 10, wH - fontS:getHeight() - 30, wW - 10, "center")
end

function OVERVIEW:keypressed(key)
    if key == "r" then
        OVERVIEW.setScene("WARNING")
    end
end

return OVERVIEW

