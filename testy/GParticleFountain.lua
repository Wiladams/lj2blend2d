

local random = math.random
local functor = require("functor")
local collections = require("collections")
local queue = collections.queue

local colors = {
color(255, 192, 203),   -- PINK
color(255,255,255),     -- WHITE
color(255, 215, 0),   -- gold
}
local nColors = #colors
print("nColors: ", nColors)

--[[
local function randomColor()
  local idx = math.floor(random(1,nColors))
  print(idx)
  return colors[idx]
end
--]]

---[[
local function randomColor()
  local r = random(30,255)
  local g = random(30,255)
  local b = random(30,255)
  return color(r,g,b,255)
end
--]]

-- A simple Particle class
local Particle = {}
Particle.__index = Particle

local function vec2_add(lhs, rhs)
    lhs.x = lhs.x + rhs.x;
    lhs.y = lhs.y + rhs.y;

    return lhs
end

function Particle.new(self, position)
  local obj = {
    acceleration = {x=0, y=0.05};
    velocity = {x=random(-1.0, 1.0), y=random(-1.0, 0)};
    position = {x = position.x, y = position.y};
    lifespan = 255;
    color = randomColor();
  }
  setmetatable(obj, Particle)

  return obj;
end


-- Method to update position
function Particle.update(self)
    self.velocity = vec2_add(self.velocity, self.acceleration)
    self.position = vec2_add(self.position, self.velocity)
    self.lifespan = self.lifespan - 2;

    --print("velocity: ", self.velocity.x, self.velocity.y)
end

-- Method to display
function Particle.draw(self, ctx)
    if self:isDead() then
        return false
    end
    
    --ctx:stroke(200, self.lifespan);
    ctx:noStroke()
    --ctx:strokeWidth(1);
    self.color.a = self.lifespan
    ctx:fill(self.color);
    --ctx:ellipse(self.position.x, self.position.y, 12, 12);
    ctx:rect(self.position.x, self.position.y, 12, 12)
end

-- Is the particle still useful?
function Particle.isDead(self)
  return self.lifespan <= 0;
end


--[[
-- Particle System
--]]
local GParticleFountain = {}
local GParticleFountain_mt = {
  __index = GParticleFountain;
}

function GParticleFountain.new(self, obj)

  obj = obj or {}

  obj.origin = obj.origin or {x=obj.frame.width/2, y =100}
  obj.particles = queue()

  setmetatable(obj, GParticleFountain_mt)

  periodic(1000/60, functor(obj.update, obj))

  return obj;
end


function GParticleFountain.addParticle(self)
  self.particles:enqueue(Particle:new(self.origin))
end

function GParticleFountain.update(self)
  -- update all particles in the fountain
  local len = self.particles:length()
  for i=1,len do
    local particle = self.particles:dequeue()
    particle:update()
    if not particle:isDead() then
      -- if it's not dead, then put it back in the queue
      self.particles:enqueue(particle)
    end
  end

  self:addParticle()
end

function GParticleFountain.draw(self, ctx)
  --print("GParticleFountain.draw, 1.0: ", #self.particles)

  for particle in self.particles:entries() do
    particle:draw(ctx)
  end
end

return GParticleFountain
