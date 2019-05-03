
local keyboard = require("GCompKeyboard")

local function app(params)
    local win1 = WMCreateWindow(params.x, params.y, params.width, params.height)

    function win1.drawBegin(self, ctxt)
        ctxt:clear()
        ctxt:fill(180)
        ctxt:fillAll()
    
        -- draw a black border
        ctxt:stroke(BLRgba32(0xff000000))
        ctxt:strokeWidth(4)
        ctxt:strokeRect(0,0,self.width, self.height)
    
        -- draw title bar
    end
    
    local kbd = keyboard:new()
    win1:add(kbd)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app