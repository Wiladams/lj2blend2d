
local AnalogClock = require("AnalogClock")

local function app(params)
    local size = AnalogClock:getPreferredSize()

    params = params or {
        frame = {x =width - size.width-10; y =10;
            width = size.width; height = size.height }
    }

    params.frame =  {
        x =width - size.width-10; y =10;
        width = size.width; height = size.height 
    }

    local win1 = WMCreateWindow(params)
    
    -- stub this so there's no background d
    function win1.drawBackground(self, ctx)
    end

    local clock = AnalogClock:new()

    win1:add(clock)
    win1:show()

    local function drawproc()
        win1:draw();
    end
    
    periodic(1000/30, drawproc)

end

return app