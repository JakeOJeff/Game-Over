local OVERVIEW = {}

function OVERVIEW:load()
    TableTarget = {
        x = 0,
        y = 0,
        w = wW,
        h = 200
    }
end

function OVERVIEW:update(dt)
    
end

function OVERVIEW:draw()
    lg.setColor(1,0,1)
    lg.rectangle("fill", TableTarget.x, TableTarget.y, TableTarget.w, TableTarget.h - 40)
        lg.setColor(1,0,1, 0.5)

    lg.rectangle("fill", TableTarget.x, TableTarget.y + TableTarget.h - 40, TableTarget.w, 40)
    
end

return OVERVIEW

