local Button = {}
buttons = {}
local clickEffect = love.audio.newSource("assets/audio/telephone-click.mp3", "static")

function Button:new(x, y, img_normal, img_pressed, text, onClick)
    local obj = {
        x = x,
        y = y,
        img_normal = img_normal,
        img_pressed = img_pressed,
        current_img = img_normal,
        text = text,
        onClick = onClick,
        isHovered = false,
        isClicked = false,
        sound = clickEffect,
        pressedOffset = 0  -- New property for visual press effect
    }
    obj.width = img_normal:getWidth()
    obj.height = img_normal:getHeight()
    table.insert(buttons, obj)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Button:draw()
    -- Calculate render position with offset
    local renderY = self.y + self.pressedOffset
    
    -- if self.isHovered then
    --     lg.setColor(0.8, 0.8, 0.8)
    -- else
    --     lg.setColor(1, 1, 1)
    -- end
    lg.draw(self.current_img, self.x, renderY)
    lg.setColor(0, 0, 0)

    lg.setFont(fontSS)
    lg.print(self.text, self.x + self.width / 2 - fontSS:getWidth(self.text) / 2,
        renderY + self.height / 2 - fontSS:getHeight() / 2 - 3 * scale)
    lg.setColor(1, 1, 1)
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    -- Use actual y position for collision detection, not render position
    self.isHovered = mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height
end

function Button:mousepressed(x, y, button)
    if self.isHovered and button == 1 then
        self.sound:stop()
        self.sound:play()
        self.pressedOffset = 6 * scale  -- Set offset instead of modifying y
        self.current_img = self.img_pressed
        self.isClicked = true
        self.onClick()
    end
end

function Button:mousereleased(x, y, button)
    if self.isClicked and button == 1 then
        self.pressedOffset = 0  -- Reset offset instead of modifying y
        self.current_img = self.img_normal
        self.isClicked = false
    end
end

function update_buttons(dt)
    for _, btn in ipairs(buttons) do
        btn:update(dt)
    end
end

function draw_buttons()
    for _, btn in ipairs(buttons) do
        btn:draw()
    end
end

function mousepressed_buttons(x, y, button)
    for _, btn in ipairs(buttons) do
        btn:mousepressed(x, y, button)
    end
end

function mousereleased_buttons(x, y, button)
    for _, btn in ipairs(buttons) do
        btn:mousereleased(x, y, button)
    end
end

return Button