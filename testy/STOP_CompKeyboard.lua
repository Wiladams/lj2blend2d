
local keyboard = require("GCompKeyboard")

local function app(params)
    local win1 = WMCreateWindow({frame={x=120, y=60,width=640,height=480}})
    win1:setUseTitleBar(true)    
    win1:setTitle("STOP_CompKeyboard.lua")
    
    local kbd = keyboard:new({frame={x=10, y = 10, width = 640, height=290}})
    win1:add(kbd)

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app