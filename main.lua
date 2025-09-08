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
fontM = love.graphics.newFont("assets/fonts/nihonium.otf", 50 * scale)
fontH = love.graphics.newFont("assets/fonts/nihonium.otf", 150 * scale)
fontHH = love.graphics.newFont("assets/fonts/nihonium.otf", 200 * scale)


notesInFolder = {}
handCursor = love.mouse.getSystemCursor("sizeall")
crosshairCursor = love.mouse.getSystemCursor("crosshair")
transitionText = "The Professor was REVEALED to be the Murderer!"
Note:load()



local scenery = SceneryInit(
    { path = "src.end", key = "END" , default = "true" },
    { path = "src.transition", key = "TRANSITION" },
    { path = "src.reality", key = "REALITY"},
    { path = "src.telephone", key = "TELEPHONE" }
)
-- NOTES
note = Note:new(40, 40,
    "The Professor aged 46 : A renowned scientist known for his groundbreaking research in quantum mechanics. He was found in his study.")
note2 = Note:new(552, 250,
    "A body was found in the library. The Victim was stabbed multiple times with a letter opener.")
note3 = Note:new(302, 60, "Library is next to the Study")
note4 = Note:new(860, 350, "Someone was working on something late at night \n - Jimmy, The Janitor")
note5 = Note:new(800, 150, "", "img-note")

beginNoteKnot(note)
endNoteKnot(note3)
beginNoteKnot(note3)
endNoteKnot(note2)
beginNoteKnot(note4)
endNoteKnot(note)
beginNoteKnot(note2)
endNoteKnot(note5)
--
scenery:hook(love)
