
local random = math.random

-- A simple Particle class
local Particle = {}
Particle.__index = Particle

local function vec2_add(lhs, rhs)
    lhs.x = lhs.x + rhs.x;
    lhs.y = lhs.y + rhs.y;

    return lhs
end

function Particle.new(self, position)
    --print("particle.new: ", position.x, position.y)
  local obj = {
    acceleration = {x=0, y=0.05};
    velocity = {x=random(-1.0, 1.0), y=random(-1.0, 0)};
    position = {x = position.x, y = position.y};
    lifespan = 255;
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
    
    self:update();

    ctx:stroke(200, self.lifespan);
    --noStroke()
    ctx:strokeWidth(2);
    ctx:fill(127, self.lifespan);
    ctx:ellipse(self.position.x, self.position.y, 12, 12);
end

-- Is the particle still useful?
function Particle.isDead(self)
  return self.lifespan < 0;
end

-- Particle System
local ParticleSystem = {}
setmetatable(ParticleSystem, {
  __call = function(self, ...)
    return self:new(...)
  end;
})
local ParticleSystem_mt = {
  __index = ParticleSystem;
}

function ParticleSystem.new(self, params)
  local obj = {
    origin = {x=params.frame.x, y=params.frame.y};
    particles = {};
  }
  setmetatable(obj, ParticleSystem_mt)

  -- create a few particles
  --for i=1,1000 do
  --  obj:addParticle();
  --end

  return obj;
end

function ParticleSystem.addParticle(self)
  table.insert(self.particles, Particle:new(self.origin));
  --print("particle added: ", #self.particles)
end

function ParticleSystem.draw(self, ctx)
    self:addParticle()

  for i = #self.particles,  1, -1 do
    local p = self.particles[i];
    p:draw(ctx);
    if (p:isDead()) then
        --print("remove deac")
      table.remove(self.particles,1);
    end
  end
end

return ParticleSystem
