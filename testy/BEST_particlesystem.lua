
local ParticleSystem = require("ParticleSystem")

local function app(params)
    local win1 = WMCreateWindow(params.frame.x, params.frame.y, params.frame.width, params.frame.height)
    local psys = ParticleSystem:new({frame = {x=params.frame.width/2, y = 100, width = params.frame.width, height=params.frame.height}})

    function win1.mouseDown(self, event)
        -- add a new system
        psys = ParticleSystem:new({frame = {x=event.x, y=event.y,width=self.frame.width, height =self.frame.height}})
        self:add(psys)
    end

    win1:add(psys)
    win1:show()

    local function drawproc()
        win1:draw()
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