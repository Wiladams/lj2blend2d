
local graphic = require("GSVGColorDisplay")

local function app(params)
    local win1 = WMCreateWindow(params)
    local g = graphic:new({frame = {x=40, y = 40, width = params.frame.width, height = params.frame.height}})

    win1:add(g)
    win1:show()

    local function drawproc()
         win1:draw()
    end

    periodic(1000/20, drawproc)
end

return app