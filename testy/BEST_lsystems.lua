
local cos, sin = math.cos, math.sin
local random = math.random
local radians = math.rad

local GLSystem = {}
GLSystem.__index = GLSystem

function GLSystem.new(self, obj)
  obj = obj or {}

  -- TURTLE STUFF:
  obj.x = obj.x or 0
  obj.y = obj.y or obj.frame.height
  obj.currentangle = 0;
  obj.step = 20;
  obj.angle = 90;

  -- LINDENMAYER STUFF (L-SYSTEMS)
  obj.thestring = 'A'; -- "axiom" or start of the string
  obj.numloops = 5; -- how many iterations to pre-compute
  obj.therules = {}; -- array for rules
  obj.therules[1] = {'A', '-BF+AFA+FB-'}; -- first rule
  obj.therules[2] = {'B', '+AF-BFB-FA+'}; -- second rule

  obj.whereinstring = 1; -- where in the L-system are we?

  setmetatable(obj, GLSystem)

  -- COMPUTE THE L-SYSTEM
  for i = 1, obj.numloops do
    obj.thestring = obj:lindenmayer(obj.thestring);
  end

  return obj;
end




-- interpret an L-system
function GLSystem.lindenmayer(self, s)
  local outputstring = ''; -- start a blank output string

  -- iterate through 'therules' looking for symbol matches:
  for i = 1, #s do
    local ismatch = false; -- by default, no match
    for j = 1, #self.therules do
      if string.sub(s,i,i) == self.therules[j][1]  then
        outputstring = outputstring..self.therules[j][2]; -- write substitution
        ismatch = true; -- we have a match, so don't copy over symbol
        break; -- get outta this for() loop
      end
    end
    -- if nothing matches, just copy the symbol over.
    if ismatch == false then 
        outputstring = outputstring..string.sub(s,i,i);
    end
  end

  return outputstring; -- send out the modified string
end

-- this is a custom function that draws turtle commands
function GLSystem.drawIt(self, ctx, k) 

  if (k=='F') then -- draw forward
    -- polar to cartesian based on step and currentangle:
    local x1 = self.x + self.step*cos(radians(self.currentangle));
    local y1 = self.y + self.step*sin(radians(self.currentangle));
    ctx:line(self.x, self.y, x1, y1); -- connect the old and the new

    -- update the turtle's position:
    self.x = x1;
    self.y = y1;
  elseif (k == '+') then
    self.currentangle = self.currentangle + self.angle; -- turn left
  elseif (k == '-') then
    self.currentangle = self.currentangle - self.angle; -- turn right
  end

  -- give me some random color values:
  local r = random(128, 255);
  local g = random(0, 192);
  local b = random(0, 50);
  local a = random(50, 100);


  -- pick a gaussian (D&D) distribution for the radius:
  local radius = 0;
  radius = radius + random(0, 15);
  radius = radius + random(0, 15);
  radius = radius + random(0, 15);
  radius = radius / 3;

  -- draw the stuff:
  ctx:fill(r, g, b, a);
  ctx:ellipse(self.x, self.y, radius, radius);
end

function GLSystem.draw(self, ctx)
    --print("win1.draw: ", ctx)
    --if not ctx then return end
    -- draw the current character in the string:
    self:drawIt(ctx, string.sub(self.thestring, self.whereinstring, self.whereinstring));
  
    -- increment the point for where we're reading the string.
    -- wrap around at the end.
    self.whereinstring = self.whereinstring +1;
    if (self.whereinstring > #self.thestring) then
      self.whereinstring = 1;
    end
end

local function app(params)
  local win1 = WMCreateWindow(params)
  win1:setUseTitleBar(true)
  
  -- negate drawing the default background
  function win1.drawBackground(self, ctx)
  end

  local sys = GLSystem:new({frame={x=0, y=0, width=params.frame.width, height=params.frame.height}})

  -- draw a background
  local ctx = win1:getDrawingContext()
  ctx:background(255)
  ctx:stroke(0)

  win1:add(sys)

  win1:show()

  local function drawproc()
    win1:draw()
  end

  -- we can use the system scheduler to do interesting
  -- things
  periodic(1000/200, drawproc)
  --while true do
  --    win1:draw()
  --    yield();
  --end
end

return app
