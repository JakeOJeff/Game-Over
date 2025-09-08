local TELEPHONE = {}
local bg = lg.newImage("assets/screens/bg-telephone.png")
local telephoneImg = lg.newImage("assets/screens/telephone-bordered.png")
local telephoneHighlightImg = lg.newImage("assets/screens/telephone-highlighted.png")
local notepadImg = lg.newImage("assets/screens/notepad-text.png")

local telButtNormal = lg.newImage("assets/screens/button-unpressed.png")
local telButtPressed = lg.newImage("assets/screens/button-normal.png")

local clearTelButtNormal = lg.newImage("assets/screens/clear-button-unpressed.png")
local clearTelButtPressed = lg.newImage("assets/screens/clear-button-normal.png")


local enterTelButtNormal = lg.newImage("assets/screens/enter-button-unpressed.png")
local enterTelButtPressed = lg.newImage("assets/screens/enter-button-normal.png")
function TELEPHONE:load()
    buttons = {}
    telnav = nav:new(self, nil, "REALITY")

    self.codes = {
        ["668231"] = "Janitor",
    }

    self.display = ""


    local no = 0
    for j = 1, 3 do
        for i = 1, 3 do
            no = no + 1
            local currentNo = no
            local x = 694 * scale + ((i - 1) * telButtPressed:getWidth() + (i - 1) * 14 * scale)
            local y = 240 * scale + ((j - 1) * telButtPressed:getHeight() + (j - 1) * 14 * scale)
            local btn = Button:new(x, y, telButtNormal, telButtPressed, tostring(currentNo), function()
                if #self.display < 6 then
                    self.display = self.display .. tostring(currentNo)
                end
            end)
        end
    end
    local fourthY = 240 * scale + (3 * telButtPressed:getHeight() + 3 * 14 * scale)
    btnClear = Button:new(694 * scale, fourthY, clearTelButtNormal, clearTelButtPressed, "<", function()
        if self.display ~= "" then
            self.display = self.display:sub(1, -2)
        end
    end)
    btnZero = Button:new(694 * scale + 1 * enterTelButtNormal:getWidth() + 1 * 14 * scale, fourthY, telButtNormal,
        telButtPressed, "0", function()
        if #self.display < 6 then
            self.display = self.display .. tostring(0)
        end
    end)
    btnEnter = Button:new(694 * scale + 2 * enterTelButtNormal:getWidth() + 2 * 14 * scale, fourthY, enterTelButtNormal,
        enterTelButtPressed, ">", function()

    end)
end

function TELEPHONE:update(dt)
    telnav:update(dt)
    update_buttons(dt)
end

function TELEPHONE:draw()
    lg.draw(bg, 0, 0)
    lg.draw(telephoneImg, 520 * scale, 100 * scale, 0, scale, scale)

    if #self.display >= 6 then
        lg.draw(telephoneHighlightImg, 520 * scale, 100 * scale, 0, scale, scale)
    end
    lg.draw(notepadImg, 520 * scale + telephoneImg:getWidth() + 40 * scale, 130 * scale, 0, scale, scale)
    draw_buttons()
    lg.setColor(41 / 255, 30 / 255, 22 / 255)

    lg.print(self.display, 690 * scale, 170 * scale)
    lg.setColor(1, 1, 1)
    telnav:draw()
end

function TELEPHONE:mousepressed(x, y, button)
    mousepressed_buttons(x, y, button)
end

function TELEPHONE:mousereleased(x, y, button)
    mousereleased_buttons(x, y, button)
end

function TELEPHONE:checkCode(code)
    for i, v in pairs(self.codes) do
        if i == code then
            
        end
    end
end

function TELEPHONE:call(name)
    self.setScene(name)
end
return TELEPHONE
