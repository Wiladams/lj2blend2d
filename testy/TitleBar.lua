local GraphicGroup = require("GraphicGroup")
local CloseBox = require("CloseBox")
local functor = require("functor")


local TitleBar = {}
setmetatable(TitleBar, {
    __index = GraphicGroup;
})
local TitleBar_mt = {
    __index = TitleBar
}    


function TitleBar.new(self, obj)
    obj = GraphicGroup:new(obj)
    obj.frame = obj.frame or {x=0,y=0,width=obj.window.frame.width, height = 36};
    obj.title = "TitleBar"
    obj.refuseFocus = true;

    setmetatable(obj, TitleBar_mt)

    local cbox = CloseBox:new({title='closebox', frame={x=obj.frame.width-32, y=2, width=30, height=30}})

    on(cbox, functor(obj.onClose, obj))
    obj:add(cbox)

    return obj
end

function TitleBar.setTitle(self, value)
    self.title = value;
    return self;
end

function TitleBar.onClose(self, event)
    --print("TitleBar.onClose: ", event)
    self.window:close()
end

function TitleBar.drawBackground(self, ctx)
    --print("TitleBar.drawBackground")
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

function TitleBar.mouseDown(self, event)
    --print("TitleBar.mouseDown")
    self.isDragging = true;
end

function TitleBar.mouseMove(self, event)
    --print("TitleBar.mouseMove: ", event.x, event.y, self.isDragging)
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
    --print("TitleBar.mouseUp: ", event.x, event.y)
    self.lastMove = nil;
    self.isDragging = false;
end

return TitleBar
