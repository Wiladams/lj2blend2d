
local Drawable = require("p5ui.Drawable")
local GGlyphInfo = Drawable:new()
GGlyphInfo.__index = GGlyphInfo

-- Convenient drawing routines
local function display(params)
    if not params then return false end

    local txt = params.text or ''
    local c = params.color or black
    local x = params.x or 0
    local y
    if not params.y then
        if params.row then
            y = params.row*rowHeight
        else
            y = rowHeight;
        end
    end

    fill(c)
    text(txt, x, y)

end

local function displayLabeledData(txt, data, row)
    display {text = txt, color = black, x = labelColumn, row = row}
    display {text = tostring(data), x = dataColumn, row = row, color = blue}
end

-- Font specific details
-- from BLFontMetrics
function GGlyphInfo.new(self)
    obj = obj or {
        frame = {
            x = 240;
            y = 80;
            width = 360;
            height = 360;
        };
    }
    obj.bounds= obj.bounds or  {
            x = 0;
            y = 0;
            width = 360;
            height = 360;
        };

    setmetatable(obj, self)
    --self.__index = self;
    
    return obj;
}

function detailArea.drawBegin(self)
    strokeWeight(2)
    stroke(0)
    fill(0xdd)
    rect(0, 0, self.frame.width, self.frame.height)
end

function detailArea.drawBody(self)
    displayLabeledData("Size:", font.impl.metrics.size , 1)
    displayLabeledData("Line Gap:", font.impl.metrics.lineGap , 2)
    displayLabeledData("X Height:", font.impl.metrics.xHeight , 3)
    displayLabeledData("Cap Height:", font.impl.metrics.capHeight , 4)
end

function detailArea.draw(self)
    push()
    translate(self.frame.x, self.frame.y)

    self:drawBegin()
    self:drawBody()
    self:drawEnd()
    
    pop()
end
