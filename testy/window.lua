--local b2d = require("blend2d.blend2d")

local GraphicGroup = require("GraphicGroup")
local DrawingContext = require("DrawingContext")
local TitleBar = require("TitleBar")


local Window = {}
setmetatable( Window, 
    { __index = GraphicGroup } 
)

local Window_mt = {
    __index = Window
}



function Window.new(self, obj)
    obj = GraphicGroup:new(obj)

    obj.isShown = true;
    
    -- add a drawing context
    obj.drawingContext = DrawingContext:new({width = obj.frame.width, height = obj.frame.height});
    obj.titleBar = TitleBar:new({
        frame = {x=0,y=0,width = obj.frame.width, height=36};
        window = obj;
    })
    obj.useTitleBar = obj.useTitleBar or false;
    obj.clientArea = GraphicGroup:new({frame=0,0,obj.frame.width, obj.frame.height})

    setmetatable(obj, Window_mt)

    obj:setUseTitleBar(obj.useTitleBar)

    obj:setup()

    return obj;
end

function Window.setup(self)
end

function Window.show(self)
    self.isShown = true;
end

function Window.hide(self)
    self.isShown = false;
end


-- A window could be using as many buffers as it wants
-- getReadyBuffer() returns the one the window wants the
-- compositor to use in rendering it's current view
function Window.getReadyBuffer(self)
    return self.drawingContext:getReadyBuffer()
end



function Window.moveTo(self, x, y)
    self.frame.x = x
    self.frame.y = y;

    return self;
end

function Window.moveBy(self, dx, dy)
    self.frame.x = self.frame.x + dx;
    self.frame.y = self.frame.y + dy;

    return self;
end

function Window.drawBackground(self, ctxt)
    ctxt:clear()
    ctxt:fill(127,180)
    ctxt:fillAll()

    -- draw a black border
    local border = 0xff000000
    if self.isFocus then
        border = 0xffff0000
    end

    ctxt:stroke(BLRgba32(border))
    ctxt:strokeWidth(4)
    ctxt:strokeRect(0,0,self.frame.width, self.frame.height)

    if self.useTitleBar then
        self.titleBar:draw(ctxt)
    end
end

function Window.setTitle(self, value)
    return self.titleBar:setTitle(value)
end

function Window.setUseTitleBar(self, useit)
    self.useTitleBar = useit;

    local clientFrame = nil

    if useit then
        clientFrame = {x=0,y=self.titleBar.frame.height,
            self.frame.width, self.frame.height-self.titleBar.frame.height}
    else
        clientFrame = {
            x=0,y=0,
            self.frame.width, self.frame.height
        }
    end
    
    self.clientArea.frame = clientFrame

    return self;
end


return Window