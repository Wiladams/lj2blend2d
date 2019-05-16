local GraphicGroup = require("GraphicGroup")

local TitleBar = {}
setmetatable(TitleBar, {
    __index = GraphicGroup;
})
local TitleBar_mt = {
    __index = TitleBar
}    


function TitleBar.new(self, win)
    local obj = {
        frame = {x=0,y=0,width=win.frame.width, height = 36};
        window = win;
        title = "TitleBar"
    }
    setmetatable(obj, TitleBar_mt)

    return obj
end

function TitleBar.draw(self, ctx)
    ctx:noStroke()
    ctx:fill(255)
    ctx:rect(0,0,self.frame.width, self.frame.height)

    ctx:fill(0)
    ctx:textAlign(CENTER, MIDDLE)
    ctx:text(self.title, self.frame.width/2, self.frame.height/2)
end

function TitleBar.setFocus(self, child)
    print("TitleBar.setFocus(): ", child)
end

function TitleBar.loseFocus(self)
    print("TitleBar.loseFocus")
    self.isDragging = false;
end

function TitleBar.mouseEvent(self, event)
    --print("TitleBar.mouseEvent: ", event.activity, event.isDragging)
    if event.activity == "mousemove" then
        return self:mouseMove(event)
    elseif event.activity == "mouseup" then
        return self:mouseUp(event)
    elseif event.activity == "mousedown" then
        return self:mouseDown(event)
    end
end

function TitleBar.mouseDown(self, event)
    self.isDragging = true;
end

function TitleBar.mouseMove(self, event)
    print("TitleBar.mouseMove: ", event.x, event.y, self.isDragging)
    if self.isDragging then
        if not self.lastMove then
            self.lastMove = {x = event.screenX, y = event.screenY};
        end
            
        local diffX = event.screenX - self.lastMove.x 
        local diffY = event.screenY - self.lastMove.y

        self.lastMove = {x=event.screenX;y=event.screenY}
        self.window:moveBy(diffX, diffY)
    end
    
    return self;
end
    
function TitleBar.mouseUp(self, event)
    print("TitleBar.mouseUp: ", event.x, event.y)
    self.lastMove = nil;
end

return TitleBar
