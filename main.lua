local SceneryInit = require("src.libs.scenery")
tween = require 'src.libs.tween'
lg = love.graphics
lk = love.keyboard
la = love.audio

Timer = require 'src.classes.timer'
Note = require 'src.classes.note'
Knot = require 'src.classes.knot'
Button = require 'src.classes.button'
nav = require 'src.classes.nav'

folder = require 'src.classes.folder'

local baseWidth = 1280
local baseHeight = 720
wW = love.graphics.getWidth()
wH = love.graphics.getHeight()

scale = math.max(wW / baseWidth, wH / baseHeight)

fontSS = love.graphics.newFont("assets/fonts/nihonium.otf", 20 * scale)
fontS = love.graphics.newFont("assets/fonts/nihonium.otf", 35 * scale)

fontM = love.graphics.newFont("assets/fonts/nihonium.otf", 50 * scale)
fontH = love.graphics.newFont("assets/fonts/nihonium.otf", 150 * scale)
fontHH = love.graphics.newFont("assets/fonts/nihonium.otf", 200 * scale)


notesInFolder = {}
handCursor = love.mouse.getSystemCursor("sizeall")
crosshairCursor = love.mouse.getSystemCursor("crosshair")
transitionText = "The Professor was REVEALED to be the Murderer!"
Note:load()



local scenery = SceneryInit(
    { path = "src.warning", key = "WARNING"},
    { path = "src.end", key = "END"},
    { path = "src.transition", key = "TRANSITION" },
    { path = "src.reality", key = "REALITY"},
    { path = "src.telephone", key = "TELEPHONE" },
    { path = "src.bookshelf", key = "BOOKSHELF"},
    { path = "src.overview", key = "OVERVIEW", default = true}

)
-- NOTES
-- note = Note:new(40, 40,
--     "The Professor aged 46 : A renowned scientist known for his groundbreaking research in quantum mechanics. He was found in his study.")
-- note2 = Note:new(552, 250,
--     "A body was found in the library. The Victim was stabbed multiple times with a letter opener.")
-- note3 = Note:new(302, 60, "Library is next to the Study")
-- note4 = Note:new(860, 350, "Someone was working on something late at night \n - Jack, The Janitor")
-- note5 = Note:new(800, 150, "", "img-note")
note  = Note:new(40,  40,  "PROFESSOR EDWARD VOSS — Age 46. Quantum physicist. \nSpecialisation: Theoretical applications of quantum entanglement.\nLast seen in this study.")
note2 = Note:new(552, 250, "VICTIM: Dr. Samuel Arkwright — Age 51. \nFound in the university library. Cause of death: multiple stab wounds, letter opener. \nTime of death estimated between 11 PM and 1 AM.")
note3 = Note:new(302, 60,  "Library is directly connected to the Study via the east corridor. \nNo keyed access required after hours.")
note4 = Note:new(860, 350, "The Professor's light was on past midnight.\nSame as the three nights before.\n— James Okafor, Night Janitor")
note5 = Note:new(800, 150, "", "img-note")  -- Photograph pinned to the board

-- Voss profile connects to his photo (same subject)
beginNoteKnot(note)
endNoteKnot(note5)

-- Voss profile connects to the geography note (he had access = opportunity)
beginNoteKnot(note)
endNoteKnot(note3)

-- Geography note connects to the crime scene (the library IS where it happened)
beginNoteKnot(note3)
endNoteKnot(note2)

-- Janitor's quote connects to the crime scene (his testimony places activity near the murder)
beginNoteKnot(note4)
endNoteKnot(note2)

-- Janitor's quote connects to Voss profile (the janitor was watching HIM specifically)
beginNoteKnot(note4)
endNoteKnot(note)
--
scenery:hook(love)
