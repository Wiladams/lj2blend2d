
local GFontIconPage = require("GFontIconPage")

local function app(params)
    local win1 = WMCreateWindow(params)
    local fip = GFontIconPage:new({frame = {x=10, y = 10, width = params.frame.width, height = params.frame.height}})

    win1:add(fip)
    win1:show()

    local function drawproc()
         win1:draw()
    end

    periodic(1000/20, drawproc)
end

return app