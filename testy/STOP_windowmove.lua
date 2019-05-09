
local keyboard = require("GCompKeyboard")

local function app(params)
    local win1 = WMCreateWindow(params.x, params.y, params.width, params.height)

    function win1.mouseDown(self, event)
        print("win1.mouseDown")
        self.isDragging = true;
    end

    function win1.mouseMove(self, event)
        --print("win1.mouseMove: ", event.x, event.y)
        if self.isDragging then
        if not self.lastMove then
            self.lastMove = {x = event.screenX, y = event.screenY};
        end
        local diffX = event.screenX - self.lastMove.x 
        local diffY = event.screenY - self.lastMove.y

        self.lastMove = {x=event.screenX;y=event.screenY}
        self:moveBy(diffX, diffY)
        end

        return self;
    end

    function win1.mouseUp(self, event)
        --print("win1.mouseUp: ", event.x, event.y)
        self.isDragging = false;
        self.lastMove = nil;
    end

    local kbd = keyboard:new({frame={x=10, y = 10, width = 640, height=290}})
    win1:add(kbd)
    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app