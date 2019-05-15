

local GraphicGroup = {}
local GraphicGroup_mt = {
    __index = GraphicGroup
}
--GraphicGroup.__index = GraphicGroup
--[[
if nil ~= baseClass then
    setmetatable( new_class, { __index = baseClass } )
end
--]]

function GraphicGroup.new(self, obj)
    --print("GraphicGroup.new: ", obj)
    obj = obj or {}
    obj.frame = obj.frame or {x=0,y=0,width=0,height=0};
    obj.children = {};

    setmetatable(obj, GraphicGroup_mt)
    --self.__index = self;

    return obj;
end

function GraphicGroup.getDrawingContext(self)
    --print("GraphicGroup.getDrawingContext: ", self.drawingContext)
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
    --print("GraphicGroup.drawChildren: ", self.children)
    
    -- draw all the children
    for _, child in ipairs(self.children) do 

        -- set clip area to child
        -- translate the context to the child's frame
       --if child.draw then
         child:draw(ctxt)
       --end
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

function GraphicGroup.gainFocus(self)
    self.isFocus = true;
end

function GraphicGroup.loseFocus(self)
    self.isFocus = false;
end

--[[
    Keyboard event
]]
function GraphicGroup.keyEvent(self, event)
    print("GraphicGroup.keyEvent: ", event.activity)
end

function GraphicGroup.ConvertFromParent(self, x, y)
    return x-self.frame.x, y-self.frame.y
end

-- complex behavior here.  Deal with cases where
-- there's an active child or not, and switching
-- between children
function GraphicGroup.mouseEvent(self, event)
    --print("mouse: ", event.activity, event.x, event.y)


    for child in self:childrenInReverseZOrder(event.parentX, event.parentY) do

        local x, y = self:ConvertFromParent(event.parentX, event.parentY)
        event.x = x;
        event.y = y;

        -- if the child can handle mouse events
        -- then figure out what to do
        if child.mouseEvent then
            if self.activeChild then
                if child == self.activeChild then
                    child:mouseEvent(event)
                    return self
                end

                if event.activity == 'mousedown' then
                    self.activeChild:loseFocus()
                    self.activeChild = child
                    self.activeChild:gainFocus()
                    return self
                elseif event.activity == "mousemove" then
                    -- tell current active child the mouse has left
                    event.activity = "mouseleave"
                    self.activeChild:mouseEvent(event)

                    -- tell child mouse is hovering
                    event.activity = "mousehover"
                    child:mouseEvent(event)
                    return self
                end 
            end


            -- the child is not the currently active one
            -- so figure out if change should occur
            
            return self;
        end

        -- if the child doesn't do mouse events
        -- just get the next child at the position
        -- and try again
    end

    -- If we are here, then the mouse activity falls outside
    -- any of the children, so it's on the body of the group
    -- itself.

    if event.activity == "mouseup" then
        if self.activeChild then
            self.activeChild:loseFocus()
            self.activeChild = nil
        end
        
        return self:mouseUp(event)
    elseif event.activity == "mousedown" then
        print("GraphicGroup.mouseEvent, mousedown parent")
        if self.activeChild then
            self.activeChild:loseFocus()
            self.activeChild = nil;
        end
        return self:mouseDown(event)
    elseif event.activity == "mousehover" then
        return self:mouseHover(event)
    elseif event.activity == "mousemove" then
        return self:mouseMove(event)
    end

    -- and if we're here, we don't understand the mouse
    -- event, so we can just return false
    return false;



--[[
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
--]]
end



function GraphicGroup.mouseDown(self, event)
end

function GraphicGroup.mouseUp(self, event)
end

function GraphicGroup.mouseMove(self, event)
end

function GraphicGroup.mouseHover(self, event)
end

return GraphicGroup

