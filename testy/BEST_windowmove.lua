
--local keyboard = require("GCompKeyboard")

local TitleBar = require("TitleBar")


local function app(params)
    local win1 = WMCreateWindow(params)
    

    --local kbd = keyboard:new({frame={x=10, y = 10, width = 640, height=290}})
    local titlebar = TitleBar:new({
        frame = {x=0,y=0,width = win1.frame.width, height=36};
        window = win1;
    })

    win1:add(titlebar)
    --win1:add(kbd)

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app