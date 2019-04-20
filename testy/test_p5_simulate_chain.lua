package.path = "../?.lua;"..package.path;

require("p5")

local Spring2D = {}
setmetatable(Spring2D, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local Spring2D_mt = {
    __index = Spring2D
}

function Spring2D.new(self, xpos, ypos, m, g)
    local obj = {
        x = xpos;   -- The x- and y-coordinates
        y = ypos;
        vx = 0;     -- The x- and y-axis velocities
        vy = 0;
        mass = m;
        gravity = g;
        radius = 30;
        stiffness = 0.2;
        damping = 0.7;
    }

    setmetatable(obj, Spring2D_mt)

    return obj;
end

function Spring2D.update(self, targetX, targetY)
    local forceX = (targetX - self.x) * self.stiffness;
    local ax = forceX / self.mass;
    self.vx = self.damping * (self.vx + ax);
    self.x = self.x + self.vx;
    local forceY = (targetY - self.y) * self.stiffness;
    forceY = forceY + self.gravity;
    local ay = forceY / self.mass;
    self.vy = self.damping * (self.vy + ay);
    self.y = self.y + self.vy;
end

function Spring2D.display(self, nx, ny)
    noStroke();
    ellipse(self.x, self.y, self.radius * 2, self.radius * 2);
    stroke(255);
    line(self.x, self.y, nx, ny);
end

local s1, s2;
local gravity = 9.0;
local mass = 2.0;

local springs = {}
local headSpring = nil

function addSpring()
    local aspring = Spring2D(0.0, width / 2, mass, gravity);
    
    if not headSpring then
        headSpring = aspring
    else
        table.insert(springs, aspring)
    end
end

function reset()
  -- Inputs: x, y, mass, gravity
  springs = {}
  headSpring = nil;

  addSpring();
  addSpring();

end

function setup()
  fill(255, 126);
  reset();
end

function draw()
  background(0);
  
  if not mouseX then return end


    headSpring:update(mouseX, mouseY);
    headSpring:display(mouseX, mouseY);
    
    -- iterate through rest of springs
    local currentSpring = headSpring
    for _, spring in ipairs(springs) do
        spring:update(currentSpring.x, currentSpring.y);
        spring:display(currentSpring.x, currentSpring.y);
        currentSpring = spring
    end
end

local T_SP = string.byte(' ')
local VK_UP = 38

function keyReleased(event)
    --print("keyReleased: ", event, keyCode)
    if keyCode == VK_UP then
        addSpring();
    end
end

function keyTyped(event)
    print("keyTyped: ", event, keyCode)
    if keyCode == T_SP then
        reset()
    end
end

go {width = 1920, height=1080, frameRate=30}