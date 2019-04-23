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
    local obj = {}
    setmetatable(obj, P5Status_mt)

    return obj
end

function P5Status.draw(self)
    -- Frame the area

    rectMode(CORNER)
    fill(0xCC, 126)
    rect(0,height-20, width, 20)
    
    -- Draw the text
    fill(0)
    local frameText = string.format("Set: %d Frame: %d  Rate: %f    Mouse: %d  %d", frameRate(), frameCount, frameCount/seconds(),
        mouseX or 0, mouseY or 0)
    text(frameText, 10, height-4)

end


return P5Status
