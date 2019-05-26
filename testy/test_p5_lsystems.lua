package.path = "../?.lua;"..package.path;

require("p5")

-- TURTLE STUFF:
local x, y; -- the current position of the turtle
local currentangle = 0; -- which way the turtle is pointing
local step = 20; -- how much the turtle moves with each 'F'
local angle = 90; -- how much the turtle turns with a '-' or '+'

-- LINDENMAYER STUFF (L-SYSTEMS)
local thestring = 'A'; -- "axiom" or start of the string
local numloops = 5; -- how many iterations to pre-compute
local therules = {}; -- array for rules
therules[1] = {'A', '-BF+AFA+FB-'}; -- first rule
therules[2] = {'B', '+AF-BFB-FA+'}; -- second rule

local whereinstring = 1; -- where in the L-system are we?

function setup()
  background(255);
  stroke(0, 0, 0, 255);

  -- start the x and y position at lower-left corner
  x = 0;
  y = height-1;

  -- COMPUTE THE L-SYSTEM
  for i = 1, numloops do
    thestring = lindenmayer(thestring);
  end
end

function draw()

  -- draw the current character in the string:
  drawIt(string.sub(thestring, whereinstring, whereinstring));

  -- increment the point for where we're reading the string.
  -- wrap around at the end.
  whereinstring = whereinstring +1;
  if (whereinstring > #thestring) then
    whereinstring = 1;
  end

end

-- interpret an L-system
function lindenmayer(s)
  local outputstring = ''; -- start a blank output string

  -- iterate through 'therules' looking for symbol matches:
  for i = 1, #s do
    local ismatch = false; -- by default, no match
    for j = 1, #therules do
      if string.sub(s,i,i) == therules[j][1]  then
        outputstring = outputstring..therules[j][2]; -- write substitution
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
function drawIt(k) 

  if (k=='F') then -- draw forward
    -- polar to cartesian based on step and currentangle:
    local x1 = x + step*cos(radians(currentangle));
    local y1 = y + step*sin(radians(currentangle));
    line(x, y, x1, y1); -- connect the old and the new

    -- update the turtle's position:
    x = x1;
    y = y1;
  elseif (k == '+') then
    currentangle = currentangle + angle; -- turn left
  elseif (k == '-') then
    currentangle = currentangle - angle; -- turn right
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
  fill(r, g, b, a);
  ellipse(x, y, radius, radius);
end

go {width=1280, height=768, frameRate=30}