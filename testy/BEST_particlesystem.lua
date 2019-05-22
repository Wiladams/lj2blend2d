
local ParticleSystem = require("ParticleSystem")

local function app(params)
    local win1 = WMCreateWindow(params)
    local psys = ParticleSystem:new({frame = {x=0;y=0;width=params.frame.width, height=params.frame.height}})

    function win1.mouseDown(self, event)
        -- add a new system
        psys = ParticleSystem:new({frame = {x=event.x, y=event.y,width=self.frame.width, height =self.frame.height}})
        self:add(psys)
    end

    win1:add(psys)
    win1:show()

    local function drawproc()
        --print("drawproc 1.0")
        win1:draw()
        --print("drawproc 2.0")
    end

    --periodic(1000/30, drawproc)

---[[
    while true do
        win1:draw()
        yield();
    end
--]]
end

return app