local FrameStatGraphic = require("FrameStatGraphic")

local function app(params)
    local win1 = WMCreateWindow(params)

    local gr = FrameStatGraphic:new({width = params.frame.width, height=20})

    win1:add(gr)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app