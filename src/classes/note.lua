-- Note.lua
local Note = {}
notes = {}
holdingNote = nil
noteDropped = nil
function Note:load()
    normalImg = lg.newImage("assets/screens/note.png")
    hoverImg = lg.newImage("assets/screens/note-hovered.png")
    crumpleImg = lg.newImage("assets/screens/note-rolled.png")
    headerImg = lg.newImage("assets/screens/header.png")
    pickupSound = la.newSource("assets/audio/paper-pickup.mp3", "static")
    crumpleSound = la.newSource("assets/audio/paper-crumple.mp3", "static")

    photoNormalImg = lg.newImage("assets/screens/photo.png")
    photoHoverImg = lg.newImage("assets/screens/photo-hovered.png")
    photoCrumpleImg = lg.newImage("assets/screens/photo-rolled.png")
    photoDefaultContentImg = lg.newImage("assets/screens/imgs/john.png")
end
function Note:new(x, y, text, type, content)
    local n = {
        x = x,
        y = y,
        text = text or "This is a note",
        dragging = false,
        holding = false,
        type = type or "text-note",
        img = normalImg,
        hoverImg = hoverImg,
        crumpleImg = crumpleImg,
        headerImg = headerImg,
        pickupSound = pickupSound,
        crumpleSound = crumpleSound,
        header = { x = 0, y = 0 },
        knotPoints = {},
    }
    if n.type == "img-note" then
        n.img = photoNormalImg
        n.hoverImg = photoHoverImg
        n.crumpleImg = photoCrumpleImg
        n.content = content or photoDefaultContentImg
    end
    n.currentImg = n.img
    local meta = setmetatable(n, { __index = self })
    table.insert(notes, meta)
    return meta
end

function Note:update(dt)
    if self.dragging then
        local mx, my = love.mouse.getPosition()
        local newX = mx - self.dragOffsetX + 10 * scale
        local newY = my - self.dragOffsetY + 10 * scale

        -- Apply border constraints
        local border = 42 * scale
        local noteWidth = self.img:getWidth()
        local noteHeight = self.img:getHeight()

        -- Clamp position to stay within borders
        self.x = math.max(border, math.min(wW - border - noteWidth, newX))
        self.y = math.max(border, math.min(wH - border - noteHeight, newY))
    end
    local mx, my = love.mouse.getPosition()
    if mx > self.x and mx < self.x + self.img:getWidth() and
        my > self.y and my < self.y + self.img:getHeight() then
        self.currentImg = self.hoverImg
        if my > self.y + self.img:getHeight() - 30 * scale and self.type == "text-note" and holdingNote == nil then
            if love.mouse.isDown(1) and not self.holding then
                self.crumpleSound:play()
                self.holding = true
            end
        elseif my > self.y + self.img:getHeight() - 30 * scale and mx > self.x + self.img:getWidth() - 40 * scale and self.type == "img-note"   and holdingNote == nil  then
            if love.mouse.isDown(1) and not self.holding then
                self.crumpleSound:play()
                self.holding = true
            end
        end
    else
        self.currentImg = self.img
    end
    self.header.x = self.x + self.img:getWidth() / 2 - self.headerImg:getWidth() / 2
    self.header.y = self.y + 10 * scale
    if activeKnot then
        love.mouse.setCursor(crosshairCursor)
    end
    -- if self.img == self.crumpleImg then
    --     self.holding = true
    -- else
    --     self.holding = false
    -- end
    if self.holding and self.dragging then
        holdingNote = self
        self.currentImg = self.crumpleImg
    end
end

function Note:draw()
    if self.dragging then
        lg.setColor(0, 0, 0, 0.5)
        lg.draw(self.currentImg, self.x - 10 * scale, self.y - 10 * scale)
    end
    lg.setColor(1, 1, 1, 1)
    lg.draw(self.currentImg, self.x, self.y)
    lg.draw(self.headerImg, self.header.x, self.header.y)
    lg.setFont(fontSS)
    if self.type == "img-note" then
        lg.draw(self.content, self.x + 18 * scale, self.y + 34 * scale, 0, 164 / self.content:getWidth() * scale,
            98 / self.content:getHeight() * scale)
    else
        lg.setColor(41 / 255, 30 / 255, 22 / 255)
        lg.printf(self.text, self.x + 20 * scale, self.y + 80 * scale, self.img:getWidth() - 40 * scale)
    end
    lg.setColor(1,1,1)
end

function Note:mousedown(x, y, button)
    -- normal dragging


    -- knot clicking
    if x > self.header.x and x < self.header.x + self.headerImg:getWidth() and
        y > self.header.y and y < self.header.y + self.headerImg:getHeight() then
        if button == 1 then
            if not activeKnot then
                -- start a new knot
                beginNoteKnot(self)
            else
                -- finish the active knot here
                endNoteKnot(self)
                love.mouse.setCursor()
            end
        end
    elseif x > self.x and x < self.x + self.img:getWidth() and
        y > self.y and y < self.y + self.img:getHeight() then
        if button == 1 then
            self.pickupSound:play()
            self.dragging = true

            love.mouse.setCursor(handCursor)
            self.dragOffsetX = x - self.x
            self.dragOffsetY = y - self.y
        end
    end
    if button == 2 then
        -- right click to cancel active knot
        if activeKnot and not activeKnot.endpoint.connected then
            for i, v in ipairs(self.knotPoints) do
                if v == activeKnot then
                    table.remove(self.knotPoints, i)
                    break
                end
            end
            for i, v in ipairs(knots) do
                if v == activeKnot then
                    table.remove(knots, i)
                    break
                end
            end
            activeKnot = nil
        end
    end
end

function beginNoteKnot(note)
    local k = Knot:new(note)
    table.insert(note.knotPoints, k)
    activeKnot = k
end

function endNoteKnot(note)
    if activeKnot and not activeKnot.endpoint.connected then
        activeKnot.endpoint.n = note
        activeKnot.endpoint.connected = true
        table.insert(note.knotPoints, activeKnot)
        activeKnot = nil
    end
end

function Note:mouserelease(button)
    if button == 1 then
        if self.dragging then
            self.x = self.x - 10 * scale
            self.y = self.y - 10 * scale
        end
        if self.holding then
            if self.x < folder.folderBg.x + folderBgImg:getWidth() * scale and self.x + self.img:getWidth() > folder.folderBg.x and
                self.y < folder.folderBg.y + folderBgImg:getHeight() * scale and
                self.y + self.img:getHeight() > folder.folderBg.y then
                -- dropped in folder
                noteDropped = self
                self.knotPoints = {}
                for i, v in ipairs(knots) do
                    if v.endpoint.n == self or v.startpoint.n == self then
                        table.remove(knots, i)
                    end
                end
            end
            self.holding = false
            holdingNote = nil
        end
        self.dragging = false

        love.mouse.setCursor()
    end
end

function update_notes(dt)
    for i, v in ipairs(notes) do
        v:update(dt)
    end
end

function draw_notes()
    for i, v in ipairs(notes) do
        v:draw()
    end
end

function mousedown_notes(x, y, button)
    -- loop from topmost note to bottommost
    for i = #notes, 1, -1 do
        local v = notes[i]
        local oldActive = activeKnot
        local oldDragging = v.dragging

        v:mousedown(x, y, button)

        -- If this note started dragging OR the activeKnot changed (started or finished), it handled the click
        if v.dragging ~= oldDragging or oldActive ~= activeKnot then
            -- bring this note to the top (last in array)
            table.remove(notes, i)
            table.insert(notes, v)
            break
        end
    end
end

function mouserelease_notes(button)
    for i, v in ipairs(notes) do
        v:mouserelease(button)
    end
end

return Note
