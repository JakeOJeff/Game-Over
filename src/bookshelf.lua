local BOOKSHELF = {}
local notepadImg = lg.newImage("assets/screens/notepad-text.png")

function BOOKSHELF:load()
    
end

function BOOKSHELF:update(dt)
    
end

function BOOKSHELF:draw()
    lg.draw(notepadImg, wW/2 - notepadImg:getWidth()/2, wH/2 - notepadImg:getHeight()/2, 0, )    
end

local function normalize(x)
    if x <= 0.5 then
        return 0
    else
        return (x - 0.5)/0.5
    end
    
end
return BOOKSHELF