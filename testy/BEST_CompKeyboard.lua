
local keyboard = require("GCompKeyboard")

local function app(params)
    local win1 = WMCreateWindow({
        frame={x=params.frame.x, y=params.frame.y,
            width=params.frame.width,height=params.frame.height
        }
    })
    win1:setTitle("STOP_CompKeyboard.lua")
    
    local kbd = keyboard:new({frame={x=0, y = 0, width = 610, height=290}})
    --local size = kbd:getPreferredSize()
    --print("kbd size: ", size.width, size.height)

    win1:add(kbd)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app