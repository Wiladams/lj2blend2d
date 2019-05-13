
local keyboard = require("GCompKeyboard")
local GraphicGroup = require("GraphicGroup")

local TitleBar = GraphicGroup:new()


function TitleBar.new(self, obj)
    obj = GraphicGroup:new(obj)
    self.__index = self;
    setmetatable(obj, self)

    return obj
end

function TitleBar.draw(self, ctx)
    ctx:noStroke()
    ctx:fill(255,7f)
    ctx:rect(0,0,self.frame.width, self.frame.height)
end

function TitleBar.mouseMove(self, event)
    --        print("TitleBar.mouseMove: ", event.x, event.y, event.isDragging)
    if event.isDragging then
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
    
function TitleBar.mouseUp(self, event)
    --print("TitleBar.mouseUp: ", event.x, event.y)
    self.lastMove = nil;
end




local function app(params)
    local win1 = WMCreateWindow(params)


    function win1.mouseMove(self, event)
--        print("win1.mouseMove: ", event.x, event.y, event.isDragging)
        if event.isDragging then
            if not self.lastMove then
                self.lastMove = {x = event.screenX, y = event.screenY};
            end
        
            local diffX = event.screenX - self.lastMove.x 
            local diffY = event.screenY - self.lastMove.y
--print("DIFF: ", diffX, diffY)
            self.lastMove = {x=event.screenX;y=event.screenY}
            self:moveBy(diffX, diffY)
        end

        return self;
    end

    function win1.mouseUp(self, event)
        --print("win1.mouseUp: ", event.x, event.y)
        self.lastMove = nil;
    end

    local kbd = keyboard:new({frame={x=10, y = 10, width = 640, height=290}})
    local titlebar = TitleBar(win1)

    win1:add(kbd)
    win1:add(titlebar)

    win1:show()

    while true do
        win1:draw()
        yield();
    end
end

return app