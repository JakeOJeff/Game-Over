-- Knot.lua
local Knot = {}
knots = {}
activeKnot = nil

function Knot:new(note)
    local n = {
        startpoint = {
            n = note,
            x = note.header.x + note.headerImg:getWidth() / 2,
            y = note.header.y + note.headerImg:getHeight() / 2,
            connected = true
        },
        endpoint = {
            x = 0,
            y = 0,
            connected = false
        }
    }
    local meta = setmetatable(n, { __index = self })
    table.insert(knots, meta)
    return meta
end

function Knot:update(dt)
    local mx, my = love.mouse.getPosition()

    -- follow start note
    self.startpoint.x = self.startpoint.n.header.x + self.startpoint.n.headerImg:getWidth() / 2
    self.startpoint.y = self.startpoint.n.header.y + self.startpoint.n.headerImg:getHeight() / 2

    if not self.endpoint.connected then
        -- dragging endpoint follows mouse
        self.endpoint.x = mx
        self.endpoint.y = my
    else
        -- locked to note
        self.endpoint.x = self.endpoint.n.header.x + self.endpoint.n.headerImg:getWidth() / 2
        self.endpoint.y = self.endpoint.n.header.y + self.endpoint.n.headerImg:getHeight() / 2
    end
end

function Knot:draw()
    lg.setColor(113/255, 47/255, 62/255)
    lg.setLineWidth(3)
    lg.line(self.startpoint.x, self.startpoint.y, self.endpoint.x, self.endpoint.y)
    lg.setColor(1, 1, 1)
end
function Knot:mousedown(x, y, button)

end
function update_knots(dt)
    for i, v in ipairs(knots) do
        v:update(dt)
    end
end

function draw_knots()
    for i, v in ipairs(knots) do
        v:draw()
    end
end
function mousedown_knots(x, y, button)
    for i, v in ipairs(knots) do
        v:mousedown(x, y, button)
    end
end


return Knot
