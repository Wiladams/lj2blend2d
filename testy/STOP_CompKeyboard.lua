
local keyboard = require("GCompKeyboard")

local function app(params)
    local win1 = WMCreateWindow(params.x, params.y, params.width, params.height)

    function win1.drawBody(self, ctxt)
        ctxt:clear()
        ctxt:fill(180)
        ctxt:fillAll()
    
        -- draw a black border
        ctxt:stroke(BLRgba32(0xff000000))
        ctxt:strokeWidth(4)
        ctxt:strokeRect(0,0,self.frame.width, self.frame.height)

    end
    
    local kbd = keyboard:new({frame={x=10, y = 10, width = 640, height=290}})
    win1:add(kbd)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app