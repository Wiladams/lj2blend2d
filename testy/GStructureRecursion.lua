
local GStructureRecursion = {}
GStructureRecursion.__index = GStructureRecursion



function GStructureRecursion.new(self, obj)
    obj = obj or {}

    obj.frame = obj.frame or {0,0,720,400}

    obj.y = obj.y or obj.frame.height/2
    obj.x = obj.x or 0
    
    setmetatable(obj, GStructureRecursion)

    return obj;
end

function GStructureRecursion.draw(self, dc)
    --print("draw: ", dc)
    dc:noStroke(); 
    dc:ellipseMode(CENTER)
    self:drawCircle(dc, self.frame.width/2, self.y, 6);
end
  
function GStructureRecursion.drawCircle(self, dc, x, radius, level)
    local tt = 126 * level/4.0;
    dc:fill(tt);
    dc:ellipse(x, self.frame.height/2, radius*2, radius*2);      
    if(level > 1) then
      level = level - 1;
      self:drawCircle(dc, x - radius/2, radius/2, level);
      self:drawCircle(dc, x + radius/2, radius/2, level);
    end
end

return GStructureRecursion
