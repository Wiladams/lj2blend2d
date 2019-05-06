
local keyboard = require("GPianoKeyboard")
local g = keyboard:new()

local function app(params)
    local win1 = WMCreateWindow(params.x, params.y, params.width, params.height)
    local kbd = keyboard:new({scale = {x=params.width, y=params.height}})

--[[    
    function win1.drawBegin(self, ctx)
        ctx:clear()
        ctx:fill(180)
        ctx:fillAll()
    
        ctx:resetTransform()
        ctx:scale(params.width, params.height)
        -- draw a black border
        --ctxt:stroke(BLRgba32(0xff000000))
        --ctxt:strokeWidth(4)
        --ctxt:strokeRect(0,0,self.width, self.height)

    end
--]]    

    win1:add(kbd)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app