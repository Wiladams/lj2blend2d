-- A status line graphic that shows
-- the state of a P5 rendering environment

local P5Status = {}
setmetatable(P5Status, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local P5Status_mt = {
    __index = P5Status;
}

function P5Status.new(self, ...)
    local obj = obj or {
        originX = 0;
        originY = 0;
        height = 20;
        lasttime = 0;
    }
    obj.height = obj.height or 20;

    setmetatable(obj, P5Status_mt)

    return obj
end

function P5Status.draw(self)
    -- Frame the area
    local thistime = millis();
    local elapsed = thistime - self.lasttime;
    self.lasttime = thistime;

    push()
    translate(self.originX, self.originY)
    rectMode(CORNER)
    fill(0xCC, 126)
    rect(0,0, width, self.height)
    
    -- Draw the text
    fill(0)
    local frameText = string.format("Fate: %d Frame: %d  Period: %d Rate: %f    Mouse: %d  %d", 
        frameRate(), frameCount, elapsed, frameCount/seconds(),
        mouseX or 0, mouseY or 0)


    text(frameText, 10, self.height-4)
    pop()
    
end


return P5Status
