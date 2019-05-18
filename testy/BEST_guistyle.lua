local GUIStyle = require("guistyle")

local function app(params)
    local win1 = WMCreateWindow(params)
    local styler = GUIStyle:new()


    function win1.drawForeground(self, ctx)
        styler:DrawSunkenRect(ctx, 10, 40, 200, 40)
        styler:DrawRaisedRect(ctx, 240, 40, 200, 40)

        --styler:DrawFrame(ctx, 10, 10, 200, 40, GUIStyle.FrameStyle.Sunken)
    end


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