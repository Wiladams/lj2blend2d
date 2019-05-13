-- A status line graphic that shows
-- the state of a P5 rendering environment

local FrameStatGraphic = {}
setmetatable(FrameStatGraphic, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local FrameStatGraphic_mt = {
    __index = FrameStatGraphic;
}

function FrameStatGraphic.new(self, obj)
    obj = obj or {
        x = 0;
        y = 0;
        height = 20;
        width = 640;
        lasttime = 0;
    }
    obj.x = obj.x or 0
    obj.y = obj.y or 0
    obj.height = obj.height or 20;
    obj.width = obj.width or 640;
    obj.lasttime = obj.lasttime or 0;

    setmetatable(obj, FrameStatGraphic_mt)

    return obj
end

function FrameStatGraphic.draw(self, ctxt)
    -- Frame the area
    local thistime = millis();
    local elapsed = thistime - self.lasttime;
    self.lasttime = thistime;

    --ctxt:push()
    --ctxt:translate(self.x, self.y)
    ctxt:rectMode(CORNER)
    ctxt:fill(0xCC, 126)
    ctxt:noStroke()
    ctxt:rect(self.x,self.y, self.width, self.height)
    
    -- Draw the text
    ctxt:fill(0)
    local frameText = string.format("Set Rate: %3d Frame: %5d  Period: %2d Rate: %3.2f    Mouse: %d  %d", 
        FrameRate, frameCount, elapsed, frameCount/seconds(),
        mouseX or 0, mouseY or 0)
--print("STATS: ", frameText)

    ctxt:text(frameText, 10, self.height-4)
    --ctxt:pop()
    
end


return FrameStatGraphic
