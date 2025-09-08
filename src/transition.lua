local TRANSITION = {}
local END = require("src.end")

function TRANSITION:load()
    transitionTextArray = {}
    for i = 1, #transitionText do
        transitionTextArray[i] = transitionText:sub(i, i)
    end
        self.time = 0
end

function TRANSITION:update(dt)
    self.time = self.time + dt

    if self.time > 8 then
        END.theme_rev:stop()
        TRANSITION.setScene("REALITY")
    end
end

function TRANSITION:draw()
    lg.setColor(1, 1, 1)
    lg.setFont(fontM)
    
    local totalWidth = fontM:getWidth(transitionText) * scale
    local startX = wW / 2 - totalWidth / 2
    local baseY = wH / 2 - fontM:getHeight() / 2
    
    local currentX = startX
    
    for i, char in ipairs(transitionTextArray) do
        local waveHeight = 5 * scale  -- amplitude
        local waveSpeed = 3    -- speed
        local waveFreq = 0.2   -- frequency
        
        local waveY = math.sin(self.time * waveSpeed + i * waveFreq) * waveHeight
        
        lg.print(char, currentX, baseY + waveY)
        
        currentX = currentX + fontM:getWidth(char) * scale
    end
end

return TRANSITION