local Drawable = require("Drawable")

local GraphicGroup = Drawable:new()


function GraphicGroup.new(self, obj)
    obj = obj or {}

    obj.frame = obj.frame or {x=0,y=0,width=0,height=0};
    obj.children = {};

    setmetatable(obj, self)
    self.__index = self;

    return obj;
end

function GraphicGroup.getDrawingContext(self)
    return self.drawingContext
end

function GraphicGroup.contains(self, x, y)
    return x >= self.frame.x and x < self.frame.x+self.frame.width and
            y >= self.frame.y and y < self.frame.y+self.frame.height

end

--[[
    Adding a child will expand the child list.
    Need to decide what it does beyond that.  Should the
    frame expand as well, or should the bounds within
    the group expand.

    Probably expand the bounds, and not the frame.  Then we 
    can decide whether to scale to fit or use panning
]]
function GraphicGroup.add(self, child, after)
    table.insert(self.children, child)
end

-- an iterator over the children at a particular location
-- iterate in reverse drawing order to receive the topmost
-- visible one first.
-- The iterator does not assume any functionality of the graphic
-- other than the fact that it has a specified frame.  This is good
-- because we might be iterating for different reasons.  Maybe to send
-- a mouse event, maybe to target specific drawing
function GraphicGroup.childrenInZOrder(self, x, y)
    local function contains(frame, x, y)
        return x >= frame.x and x < frame.x+frame.width and
            y >= frame.y and y < frame.y+frame.height
    end

    local function visitor()
        for i = 1,#self.children do
            local child = self.children[i]
            if child and child.frame and contains(child.frame, x, y) then
                coroutine.yield(child)
            end
        end
    end

    return coroutine.wrap(visitor)
end

function GraphicGroup.childrenInReverseZOrder(self, x, y)
    local function contains(frame, x, y)
        return x >= frame.x and x < frame.x+frame.width and
            y >= frame.y and y < frame.y+frame.height
    end

    local function visitor()
        for i = #self.children, 1, -1 do
            child = self.children[i]
            if child.frame and contains(child.frame, x, y) then
                coroutine.yield(child)
            end
        end
    end

    return coroutine.wrap(visitor)
end


function GraphicGroup.drawChildren(self, ctxt)
    -- draw all the children
    for _, child in ipairs(self.children) do 

        -- set clip area to child
        -- translate the context to the child's frame
        child:draw(ctxt)

        -- untranslate
        -- unclip
    end
end

function GraphicGroup.drawBackground(self, ctx)
end

function GraphicGroup.drawForeground(self, ctx)
end


function GraphicGroup.draw(self, dc)
    dc = dc or self:getDrawingContext()

    self:drawBackground(dc)

    self:drawChildren(dc)

    self:drawForeground(dc)
end

--[[
    Keyboard event
]]
function GraphicGroup.keyEvent(self, event)
    print("GraphicGroup.keyEvent: ", event.activity)
end

function GraphicGroup.mouseEvent(self, event)
    -- find topmost window for mouse
    local graphic = WMWindowAt(mouseX, mouseY)
    --print("mouse: ", mouseX, mouseY, win)
    for child in self:childrenInReverseZOrder(event.x, event.y) do
        local x, y = WMScreenToWin(win, mouseX, mouseY)
        event.x = x;
        event.y = y;


    if event.activity == "mousemove" then
        if win then
            if win == wmFocusWindow then
                win:mouseEvent(event)
            else
                event.activity = "mousehover"
                win:mouseEvent(event)
            end
        end
    elseif event.activity == "mousedown" then
        if win then
            if win ~= wmFocusWindow then
                WMSetFocus(win)
            end
            win:mouseEvent(event)
        else
            WMSetFocus(nil)
        end
    elseif event.activity == "mouseup" then
        if win then
            if win == wmFocusWindow then
                win:mouseEvent(event)
            else
                WMSetFocus(win)
            end
        else
            WMSetFocus(nil)
        end
    else
        if win and win == wmFocusWindow then
            win:mouseEvent(event)
        end
    end

        self.lastMouseWindow = win;
    end

end

--[[
function GraphicGroup.mouseEvent(self, event)
   -- ignoring wheel, hover
    --print("GraphicGroup.mouseEvent: ", event.activity, event.x, event.y)

    -- figure out which graphic can deal with the event
    -- hand it off.

    -- otherwise, process it within this object itself
    if event.activity == "mousedown" then
        self:mouseDown(event)
    elseif event.activity == "mouseup" then
        self:mouseUp(event)
    elseif event.activity == "mousemove" then
        self:mouseMove(event)
    elseif event.activity == "mousehover" then
        self:mouseHover(event)
    end

 end
--]]

function GraphicGroup.mouseDown(self, event)
end

function GraphicGroup.mouseUp(self, event)
end

function GraphicGroup.mouseMove(self, event)
end

function GraphicGroup.mouseHover(self, event)
end

return GraphicGroup

