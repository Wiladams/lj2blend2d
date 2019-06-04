
local graphic = require("GSVGColorDisplay")
local radians = math.rad

local function app(params)
    local winFrame = {frame = {x=0,y=0, width = params.frame.height, height = params.frame.width}}
    --local winFrame = {frame = {x=0,y=0, width = params.frame.width, height = params.frame.height}}
    local win1 = WMCreateWindow(winFrame)
    local g = graphic:new({frame = {x=0, y = 0, width = params.frame.width, height = params.frame.height}})

    local ctx = win1:getDrawingContext()
    ctx:translate(0, params.frame.height)
    ctx:rotate(radians(-90))
    --ctx:translate(-params.frame.width/2, -params.frame.height/2)
    print("context: ", ctx)

    win1:add(g)
    win1:show()

    local function drawproc()
         win1:draw()
    end

    periodic(1000/20, drawproc)
end

return app