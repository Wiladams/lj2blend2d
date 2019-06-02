local svgcolors = require("sortedsvgcolors")
local coloring = require("coloring")
local luma = coloring.luma
local maths = require("maths")
local map = maths.map

local GSVGColorDisplay = {
    rowSize = 60;
    columnSize = 200;
    maxColumns = 8;
    fontSize = 12;
}
local GSVGColorDisplay_mt = {
    __index = GSVGColorDisplay;
}

function GSVGColorDisplay.getPreferredSize(self)
    
    local rows = (#svgcolors / 16) + 1
    local columns = 16;

    return {width = self.maxColumns * self.columnSize, height = rows*self.rowSize}
end

function GSVGColorDisplay.new(self, params)
    local obj = {}
    obj.frame = params.frame or {x=0,y=0,width = size.width, height = size.height}
    obj.maxColumns = params.maxColumns or self.maxColumns
    obj.columnSize = params.columnSize or self.columnSize;
    obj.rowSize = params.rowSize or self.rowSize;
    obj.fontSize = params.fontSize or self.fontSize;
    obj.refuseFocus = true;     -- just want to do hover, not become a focus
    obj.colors = svgcolors;

    setmetatable(obj, GSVGColorDisplay_mt)

    return obj;
end

-- Needed to be a target of mouse events
function GSVGColorDisplay.frameContains(self, x, y)
    return x >= self.frame.x and x < self.frame.x+self.frame.width and
            y >= self.frame.y and y < self.frame.y+self.frame.height
end

function GSVGColorDisplay.convertFromParent(self, x, y)
    return x-self.frame.x, y-self.frame.y
end

function GSVGColorDisplay.graphicAt(self, x, y)
    local column = math.floor(x / self.columnSize);
    local row = math.floor(y / self.rowSize);

    local index = (row * self.maxColumns) + column + 1

    local entry = self.colors[index]
    if not entry then
        return nil
    end

    --print("graphicAt: ", x, y, column, row, index, entry)

    return {svgcolor = entry, column = column+1, row = row+1}
end

-- needed to receive mouse events
function GSVGColorDisplay.mouseEvent(self, event)
    --print("GSVGColorDisplay.mouseEvent: ", event.x, event.y)
    local x, y = self:convertFromParent(event.x, event.y)

    local entry = self:graphicAt(x, y)
    if entry then
        self.hoverColor = entry
    else
        self.hoverColor = nil;
    end
end

-- return the coordinate frame for a specified cell
function GSVGColorDisplay.frameForCell(self, column, row)
    local x = (column-1) * self.columnSize;
    local y = (row-1) * self.rowSize;
    local w = self.columnSize;
    local h = self.rowSize;

    return x, y, w, h
end

-- draw a single entry in a particular cell
function GSVGColorDisplay.drawEntry(self, ctx, svgcolor, column, row)
    if not svgcolor.c then
        svgcolor.c = color(table.unpack(svgcolor.value))
        svgcolor.lum = luma(svgcolor.value)
    end

    ctx:fill(svgcolor.c)
    --local x = (column-1) * self.columnSize;
    --local y = (row-1) * self.rowSize;
    --local w = self.columnSize;
    --local h = self.rowSize;
    local x,y,w,h = self:frameForCell(column, row)
    ctx:rect(x,y,w,h )

    -- draw the text value
    -- set the filling based on the luminance
    if svgcolor.lum > 120 then
        ctx:fill(0)
    else
        ctx:fill(255)
    end

    local cx = x + w/2
    local cy = y + h - 12
    ctx:text(svgcolor.name, cx, cy)
end

function GSVGColorDisplay.drawBackground(self, ctx)
    local column = 1
    local row = 1

    ctx:textAlign(MIDDLE, BASELINE)
    ctx:textSize(self.fontSize)
    ctx:stroke(0)
    ctx:strokeWidth(0.5)

    -- Draw everything normal
    for _, svgcolor in ipairs(svgcolors) do

        self:drawEntry(ctx, svgcolor, column, row)

        column = column + 1
        if column > self.maxColumns then
            column = 1
            row = row + 1
        end
    end
end

function GSVGColorDisplay.drawForeground(self, ctx)
    if self.hoverColor then
        local x, y, w, h = self:frameForCell(self.hoverColor.column, self.hoverColor.row)
        --print("hover: ", self.hoverColor.svgcolor.name)
        --self:drawEntry(ctx, self.hoverColor.svgcolor, self.hoverColor.column, self.hoverColor.row)
        ctx:strokeWidth(3)
        ctx:stroke(255,255,0)
        ctx:strokeRect(x,y,w,h)
    end

end

function GSVGColorDisplay.draw(self, ctx)
    self:drawBackground(ctx)
    self:drawForeground(ctx)
end

return GSVGColorDisplay
