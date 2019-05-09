
local keyboard = require("GPianoKeyboard")

local function app(params)
    local win1 = WMCreateWindow(params.x, params.y, params.width, params.height)
    local kbd = keyboard:new({frame={x= 0,y=0, width=params.width, height=params.height}, scale = {x=params.width, y=params.height}})   

    win1:add(kbd)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app