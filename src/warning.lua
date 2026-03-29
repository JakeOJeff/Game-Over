local WARNING = {}

local cur_time = os.date("*t")
local greetingText = ""

local typingAudio = love.audio.newSource("assets/audio/typing.mp3", "stream")

if cur_time.hour <= 4 then
    greetingText = "A concious time to be awake at " .. cur_time.hour .. "."
elseif cur_time.hour <= 7 then
    greetingText = "Early Riser aren't you, or didn't you sleep?"
elseif cur_time.hour <= 12 then
    greetingText =
    "Good morning, I didn't expect much of you anyway considering you are playing when the sun is still out."
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
        " Rated PG-13 (13+) and contains psychological elements and indications of violence but recommended for Mature Audiences.",
        " A personality will be played for the following statements but I hope YOU REALIZE that it's part of the character building.",
        " Elements may not be as disturbing as I'm letting you in on, but like I said, procedure.",
        " You should also realize, that THIS is an experience.",
        " Do not have abnormal expectations for a rotted mind.",
        " No one stays with childlike INNOCENCE for so long!",
        " Such thoughts SHALL NOT BE DEEMED REDEEMABLE, and may let people into more unease.",
        " Just make sure it's fun FOR YOU and everyone involved.",
        " If you need anything,",
        " just let me know,",
        " I'll make sure to ignore you.",
        " Thank you!",
        " :)",
        "             Press 'SPACE' when you're ready."
    }
    finalString = ""
    index = 1
    textIndex = 0
    maxTypingRate = 0.005
    typingRate = maxTypingRate
    maxTimer = 0.1
    timer = maxTimer
end

function WARNING:update(dt)
    if textSet[index] and textIndex <= #textSet[index] then
        if not typingAudio:isPlaying() then
            typingAudio:play()
        end
        typingRate = typingRate - 1 * dt
        if typingRate <= 0 then
            typingRate = maxTypingRate
            textIndex = textIndex + 1
            finalString = finalString .. string.sub(textSet[index], textIndex, textIndex)
        end
    elseif index < #textSet then
        if timer <= 0 then
            textIndex = 0
            index = index + 1
            timer = maxTimer
            typingAudio:play()
        else
            typingAudio:stop()
            timer = timer - 1 * dt
        end
    else
        if typingAudio:isPlaying() then
            typingAudio:stop()
        end
    end
end

function WARNING:keypressed(key)
    if key == "space" then
        WARNING.setScene("END")
    end
end

function WARNING:draw()
    lg.setFont(fontM)
    lg.printf(finalString, 10, 10, wW - 20, "left")
end

return WARNING
