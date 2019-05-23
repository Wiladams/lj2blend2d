

local GraphicGroup = {}
local GraphicGroup_mt = {
    __index = GraphicGroup
}


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

-- an iterator over the children in z-order (order of drawing)
function GraphicGroup.childrenInZOrder(self)
    local function visitor()
        for i = 1,#self.children do
            local child = self.children[i]
            coroutine.yield(child)
        end
    end

    return coroutine.wrap(visitor)
end

function GraphicGroup.activeChildrenAt(self, x, y)
    local function contains(frame, x, y)
        return x >= frame.x and x < frame.x+frame.width and
            y >= frame.y and y < frame.y+frame.height
    end

    local function visitor()
        for i = #self.children, 1, -1 do
            child = self.children[i]
            if child.frame and contains(child.frame, x, y) and
            child.mouseEvent then
                coroutine.yield(child)
            end
        end
    end

    return coroutine.wrap(visitor)
end

function GraphicGroup.interactiveChildAt(self, x, y)
    for child in self:activeChildrenAt(x,y) do
        return child;
    end
end

-- dummy implementations
function GraphicGroup.drawBegin(self, ctx)
end

-- dummy implementation
function GraphicGroup.drawEnd(self, ctx)
end

function GraphicGroup.drawChildren(self, ctxt)
    --print("GraphicGroup.drawChildren: ", self.children)
    
    -- draw all the children
    --for _, child in ipairs(self.children) do 
    for child in self:childrenInZOrder() do
        -- set clip area to child
        -- translate the context to the child's frame
        if child.draw then
            if child.frame then
                ctxt:save();
                -- set clipping rectangle
                ctxt:translate(child.frame.x, child.frame.y)
            end

            child:draw(ctxt)

            if child.frame then
                ctxt:restore();
            end
        end

    end
end

function GraphicGroup.drawBackground(self, ctx)
end

function GraphicGroup.drawForeground(self, ctx)
end


function GraphicGroup.draw(self, dc)
    dc = dc or self:getDrawingContext()

    self:drawBegin(dc)

    self:drawBackground(dc)
    self:drawChildren(dc)
    self:drawForeground(dc)

    self:drawEnd(dc);
end

function GraphicGroup.setFocus(self, child)
    if child then
        self.activeChild = child
        child:setFocus()
    else
        if self.activeChild then
            self.activeChild:loseFocus()
        end
        self.activeChild = nil;
        self.isFocus = true;
    end
end

function GraphicGroup.loseFocus(self, child)
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

    local child = self:interactiveChildAt(event.x, event.y)

    if child then
    
        -- preserve the parent coordinates
        event.parentX = event.x;
        event.parentY = event.y;
        
        -- Convert x, y coordinates to be in the space of the child
        local x, y = self:ConvertFromParent(event.x, event.y)
        event.x = x;
        event.y = y;
        --print("GraphicGroup.mouseEvent, child: ", event.x, event.y)

        if event.activity == "mousemove" then
            if child == self.activeChild then
                return child:mouseEvent(event)
            else
                event.activity = "mousehover"
                return child:mouseEvent(event)
            end
        elseif event.activity == "mousedown" then
            if child ~= self.activeChild then
                self:setFocus(child)
            end
            return child:mouseEvent(event)
        elseif event.activity == "mouseup" then
            if child == self.activeChild then
                return child:mouseEvent(event)
            else
                return self:setFocus(child)
            end
        else
            if child == self.activeChild then
                return child:mouseEvent(event)
            end
        end
    --end
    else
    -- If we are here, then the mouse activity falls outside
    -- any of the children, so it's on the body of the group
    -- itself.
    -- need to restore original event coordinates
    local x, y = self:ConvertFromParent(event.parentX, event.parentY)
    event.x = x;
    event.y = y;

    if event.activity == "mouseup" then
        if self.activeChild then
            self:setFocus()
        end
        
        return self:mouseUp(event)
    elseif event.activity == "mousedown" then
        print("GraphicGroup.mouseEvent, mousedown parent")
        self:setFocus()
        return self:mouseDown(event)
    elseif event.activity == "mousehover" then
        return self:mouseHover(event)
    elseif event.activity == "mousemove" then
        return self:mouseMove(event)
    end
    end

    -- and if we're here, we don't understand the mouse
    -- event, so we can just return false
    return false;
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

