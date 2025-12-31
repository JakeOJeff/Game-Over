local folder = {
}

folderBgImg = lg.newImage("assets/screens/folder-bg.png")
folderFrontImg = lg.newImage("assets/screens/folder-front.png")
folderView = lg.newImage("assets/screens/folder-view.png")

function folder:load()
    self.folderBg = {
        x = wW - folderBgImg:getWidth() - 30 * scale,
        y = 685 * scale,
        tweens = {
            yLifted = 532 * scale,
            yDefault = 700 * scale,
            duration = 0.25,
        }
    }

    self.folderFront = {
        x = wW - folderBgImg:getWidth() - 30 * scale,
        y = 685 * scale,
        tweens = {
            yLifted = 532 * scale,
            yDefault = 700 * scale,
            duration = 0.25,
        }
    }

    -- Initialize tweens
    self:createTweens()

    -- Track current state
    self.isHovering = false
    self.wasHovering = false
    self.opened = false
end

function folder:createTweens()
    -- Background tweens
    self.folderBgTween = {
        lift = tween.new(self.folderBg.tweens.duration, self.folderBg, { y = self.folderBg.tweens.yLifted }),
        lower = tween.new(self.folderBg.tweens.duration, self.folderBg, { y = self.folderBg.tweens.yDefault }),
    }

    -- Front tweens
    self.folderFrontTween = {
        lift = tween.new(self.folderFront.tweens.duration, self.folderFront, { y = self.folderFront.tweens.yLifted }),
        lower = tween.new(self.folderFront.tweens.duration, self.folderFront, { y = self.folderFront.tweens.yDefault }),
    }
end

function folder:update(dt)
    local mx, my = love.mouse.getPosition()
    self.isHovering = false

    if not holdingNote then
        self.isHovering = mx > self.folderBg.x and mx < self.folderBg.x + folderBgImg:getWidth() * scale and
            my > self.folderBg.y and my < self.folderBg.y + folderBgImg:getHeight() * scale
        -- if self.isHovering and not self.wasHovering then
        --
        --     self.folderBgTween.lift = tween.new(self.folderBg.tweens.duration, self.folderBg,
        --         { y = self.folderBg.tweens.yLifted })
        --     self.folderFrontTween.lift = tween.new(self.folderFront.tweens.duration, self.folderFront,
        --         { y = self.folderFront.tweens.yLifted })
        -- elseif not self.isHovering and self.wasHovering then
        --     self.folderBgTween.lower = tween.new(self.folderBg.tweens.duration, self.folderBg,
        --         { y = self.folderBg.tweens.yDefault })
        --     self.folderFrontTween.lower = tween.new(self.folderFront.tweens.duration, self.folderFront,
        --         { y = self.folderFront.tweens.yDefault })
        -- end
        self:createTweens()
        if self.isHovering then
            self.folderBgTween.lift:update(dt)
            self.folderFrontTween.lift:update(dt)
        else
            if self.folderBg.y < self.folderBg.tweens.yDefault then
                self.folderBgTween.lower:update(dt)
            end
            if self.folderFront.y < self.folderFront.tweens.yDefault then
                self.folderFrontTween.lower:update(dt)
            end
        end
    elseif holdingNote then
        self.isHovering = mx > self.folderBg.x and mx < self.folderBg.x + folderBgImg:getWidth() * scale and
            my > self.folderBg.y - folderBgImg:getHeight() * scale and
            my < self.folderBg.y + folderBgImg:getHeight() * scale
        self:createTweens()
        if self.isHovering then
            self.folderBgTween.lift:update(dt)
        end
    end
    if noteDropped then
        local droppedNote = nil
        local droppedNoteId = nil
        for i, v in ipairs(notes) do
            if v == noteDropped then
                droppedNote = v
                droppedNoteId = i
                break
            end
        end
        -- noteDropped.x = self.folderBg.x + 20 * scale
        -- noteDropped.y = self.folderBg.y + 20 * scale                                  --+ (#notesInFolder * (noteDropped.img:getHeight() * scale + 10 * scale))

        table.insert(notesInFolder, noteDropped)
        droppedNote.x = self.folderBg.x + folderBgImg:getWidth() / 2 - droppedNote.img:getWidth() / 1.5 * scale
        droppedNote.y = self.folderBg.y + 40 * scale
        if droppedNote.y > wH then
            droppedNote.knotPoints = {}
            table.remove(notes, droppedNoteId)
            noteDropped = nil
        end
    end

    self.wasHovering = self.isHovering
end

function folder:mousedown(x, y, button)
    if #notesInFolder > 1 and button == 2 and not activeKnot then
        local note = notesInFolder[#notesInFolder]
        table.insert(notes, note)

        note.dragging = true

        love.mouse.setCursor(handCursor)
        note.dragOffsetX = x - note.x
        note.dragOffsetY = y - note.y
    end
    if button == 1 then
        if self.isHovering then
            self.opened = true
        else
            self.opened = false
        end
    end
end

function folder:mouserelease(x, y, button)
    if #notesInFolder > 1 and button == 2 and not activeKnot then
        local note = notesInFolder[#notesInFolder]
        if note.dragging then
            note.x = note.x - 10 * scale
            note.y = note.y - 10 * scale
        end
    end
end

function folder:drawBack()
    if not self.opened then
        lg.draw(folderBgImg, self.folderBg.x, self.folderBg.y, 0, scale, scale)
    end
end

function folder:drawFront()
    if not self.opened then
        if not holdingNote and not noteDropped then
            lg.draw(folderBgImg, self.folderBg.x, self.folderBg.y, 0, scale, scale)
        end
        lg.draw(folderFrontImg, self.folderFront.x, self.folderFront.y, 0, scale, scale)
    elseif self.opened then
        lg.draw(folderView, 0, 0, 0, scale, scale)
    end
end

return folder
