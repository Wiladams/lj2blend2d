local FrameStatGraphic = require("FrameStatGraphic")

local function app(params)
    local win1 = WMCreateWindow(params.x,params.y, params.width, params.height)

    local gr = FrameStatGraphic:new({width = params.width, height=params.height})

    win1:add(gr)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app