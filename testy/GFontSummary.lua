local GFontSummary = {}
local GFontSummary_mt = {
    __index = GFontSummary;
}

function GFontSummary.getPrefferedSize(self)
    return {width = 1280, height=768}
end

function GFontSummary.new(self, obj)
    local psize = self:getPrefferedSize()

    obj = obj or {
        frame = {x=0,y=0,width=psize.width, height=psize.height};
    }
    
    obj.fontFamily = obj.fontFamily or "kunstler"

    setmetatable(obj, GFontSummary_mt)

    return obj;
end

local lineText = " The quick brownfox jumps over the lazy dog. 1234587890"
local lines = {
    {size = 12, lineHeight = 16;};
    {size = 18, lineHeight = 24;};
    {size = 24, lineHeight = 36;};
    {size = 36, lineHeight = 48;};
    {size = 48, lineHeight = 60;};
    {size = 60, lineHeight = 72;};
    {size = 72, lineHeight = 96;};
    {size = 96, lineHeight = 120;};
}

function GFontSummary.draw(self, ctx)

--print("GFontSummary.draw 1.0")
    ctx:setFillStyle(color(255))
    ctx:fillAll()

    ctx:save()

    ctx:fill(0);
    ctx:stroke(0);

    ctx:textAlign(LEFT, BASELINE)
    ctx:textFont("consolas")
--print("GFontSummary.draw 1.0")

    ctx:textSize(12)

    ctx:text("Font Name",2, 10)

    ctx:text("Version:", 2, 26)
    ctx:text("Attributes", 2, 42)
    ctx:strokeWidth(1)
    ctx:line(0,52, self.frame.width,52)

    ctx:textFont(self.fontFamily)
    ctx:textSize(18)
    ctx:text("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ", 2, 76)
    ctx:text("1234567890.:,; ' \" (!?) +-*/=", 2, 96)
    ctx:line(0,110, self.frame.width,110)


    ctx:translate(0, 110)
    for _, line in ipairs(lines) do 
        ctx:translate(0, line.lineHeight*1.5);
   
        -- draw the size indicator
        ctx:textFont("segoe ui")
        ctx:textSize(12)
        ctx:text(tostring(line.size), 2, 0)
   
        -- Draw the line of text
        ctx:textFont(self.fontFamily)
        ctx:textSize(line.size)
        ctx:text(lineText, 40, 0)
    end
--]]
    ctx:restore()
end

return GFontSummary
