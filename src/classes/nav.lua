local nav = {}
navs = {}
navImg = love.graphics.newImage("assets/screens/nav.png")

function nav:new(current, left, right)

    local n = {
        current = current,
        left = left or nil,
        right = right or nil,
        img = navImg,
    }
    local meta = setmetatable(n, { __index = self })
    table.insert(navs, meta)
    return meta
end

function nav:update(dt)
    local mx, my = love.mouse:getPosition()
    if self.left then
        if love.mouse.isDown(1) and mx > 5 * scale and mx < 5 * scale + self.img:getWidth() and my > wH/2 - self.img:getHeight()/2 and my < wH/2 + self.img:getHeight()/2 then
            self.current.setScene(self.left)
                collectgarbage("collect")
        end
    end
    if self.right then
        if love.mouse.isDown(1) and mx > wW - 5 * scale - self.img:getWidth() and mx < wW - 5 * scale and my > wH/2 - self.img:getHeight()/2 and my < wH/2 + self.img:getHeight()/2 then
            self.current.setScene(self.right)
                collectgarbage("collect")
        end
    end
end

function nav:draw()
    local wavingY = math.sin(love.timer.getTime() * 5 + 15) * 3
    if self.left then
        lg.draw(self.img, 5 * scale, wH/2 - self.img:getHeight()/2 + wavingY)
    end
    if self.right then
        lg.draw(self.img, wW - 5 * scale , wH/2 - self.img:getHeight()/2 + wavingY, 0,-1, 1)
    end
end

function update_navs(dt)
    for i, v in ipairs(navs) do
        v:update(dt)
    end
end

function draw_navs()
    for i, v in ipairs(navs) do
        v:draw()
    end
end


return nav
