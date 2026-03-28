local WARNING = {}

local cur_time = os.date("*t")
local greetingText = ""

if cur_time.hour <= 4 then
    greetingText = "A concious time to be awake at ".. cur_time.hour .. "."
elseif cur_time.hour <= 7 then
    greetingText = "Early Riser aren't you, or didn't you sleep?"
elseif cur_time.hour <= 12 then
    greetingText = "Good morning, I didn't expect much of you anyway considering you are playing when the sun is still out."
elseif cur_time.hour <= 16 then
    greetingText = "What a relaxing afternoon that we have here!"
elseif cur_time.hour <= 21 then
    greetingText = "A long day with responsibilities, work, pressure and rising tension. Welcome!"
elseif cur_time.hour <= 23 then
    greetingText = "Ahh, what a way to end the day! Hail Hail!"
end



function WARNING:load()
    textSet = {
        greetingText,
        " I have to warn you a few things.",
        " Don't worry, its just procedure, nothing too much and too less.",
        " I'm not here to make you sign a ToS, heck even I don't read it!",
        " I just have to let you know that elements in the game may be disturbing for some users.",
        " Rated PG-13 but recommended for Mature Audiences.",
        " Elements may not be as disturbing as I'm letting you in on, but like I said, procedure.",
        " If you need anything,",
        " just let me know,",
        " I'll make sure to ignore you",
        " Thank you!",
        " :)"
    }
    finalString = ""
    index = 1
    textIndex = 0
    maxTypingRate = 0.05
    typingRate = maxTypingRate
    maxTimer = 3
    timer = maxTimer
end

function WARNING:update(dt)
    if textIndex <= #textSet[index] then
        typingRate = typingRate - 1 * dt
        if typingRate <= 0 then
            typingRate = maxTypingRate
            textIndex = textIndex + 1
            finalString = finalString .. string.sub(textSet[index], textIndex, textIndex)
        end
    else
        textIndex = 0
        index = index + 1
    end
end

function WARNING:draw()
    lg.print(finalString)
end

return WARNING