
local keyboard = require("GPianoKeyboard")

local function app(params)
    local win1 = WMCreateWindow(params)
    local kbd = keyboard:new({frame={x= 0,y=0, width=params.frame.width, height=params.frame.height}, scale = {x=params.frame.width, y=params.frame.height}})   

    win1:add(kbd)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app