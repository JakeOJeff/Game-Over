local warning = {}

local cur_time = os.date("*t")
local greetingText = ""

if cur_time.hour <= 4 then
    greetingText = "A concious time to be awake at ".. cur_time.hour
elseif cur_time.hour <= 7 then
    greetingText = "Early Riser aren't you, or didn't you sleep?"
elseif cur_time.hour <= 12 then
    greetingText = "I didn't expect you to"
end



function warning:load()

end

function warning:update(dt)
    
end

function warning:draw()
    
end

return warning