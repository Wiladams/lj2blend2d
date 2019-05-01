
local GStructureRecursion = {}
setmetatable(GStructureRecursion, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local GStructureRecursion_mt = {
    __index = GStructureRecursion
}

function GStructureRecursion.new(self, obj)
    obj = obj or {}
    obj.width = obj.width or 720
    obj.height = obj.width or 400
    obj.y = obj.y or obj.height/2
    obj.x = obj.x or 0
    
    setmetatable(obj, GStructureRecursion_mt)

    return obj;
end

function GStructureRecursion.draw(self, dc)
    --print("draw: ", dc)
    dc:noStroke(); 
    dc:ellipseMode(CENTER)
    self:drawCircle(dc, self.width/2, self.y, 6);
end
  
function GStructureRecursion.drawCircle(self, dc, x, radius, level)
    local tt = 126 * level/4.0;
    dc:fill(tt);
    dc:ellipse(x, self.height/2, radius*2, radius*2);      
    if(level > 1) then
      level = level - 1;
      self:drawCircle(dc, x - radius/2, radius/2, level);
      self:drawCircle(dc, x + radius/2, radius/2, level);
    end
end

return GStructureRecursion
