
local radians = math.rad 


local AngleIndicator = {}
local AngleIndicator_mt = {
    __index = AngleIndicator
}

function AngleIndicator.getPreferredSize(self)
    return {width = 200, height = 200}
end

function AngleIndicator.new(self, obj)
    local size = self:getPreferredSize()

    obj = obj or {
        frame={x=0, y=0, width=size.width, height=size.height};
    }

    obj.value = obj.value or 0

    obj.frame.width = obj.frame.width or size.width;
    obj.frame.height = obj.frame.height or size.height;
    
    obj.centerX = obj.frame.width/2
    obj.centerY = obj.frame.height/2

    --print("center: ", obj.centerX, obj.centerY)
    
    setmetatable(obj, AngleIndicator_mt)

    return obj
end

function AngleIndicator.getFrame(self)
    return self.frame
end

function AngleIndicator.drawIndicator(self, ctx)
    ctx:save()

    -- Do the rotation thing
    ctx:translate(self.centerX, self.centerY)
    ctx:rotate(self.value)

    -- Draw the indicator line
    ctx:strokeWidth(1)
    ctx:stroke(255,0,0)
    ctx:line(0,0,self.centerX, 0)
    
    ctx:restore()
 end

function AngleIndicator.draw(self, ctx)

    ctx:save();

    -- fill background
    ctx:ellipseMode(RADIUS);
    ctx:stroke(255);
    ctx:strokeWidth(2);
    ctx:fill(32,32,32);
    ctx:circle(self.centerX, self.centerY, self.frame.width/2)

    self:drawIndicator(ctx);

    ctx:restore()
end

return AngleIndicator
