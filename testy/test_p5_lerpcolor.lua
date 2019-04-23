package.path = "../?.lua;"..package.path;

require("p5")


function setup()
    background(255);
    noStroke();
end
  
function draw() 
    background(255);
    local from = color(255, 0, 0, 0.2 * 255);
    local to = color(0, 0, 255, 0.2 * 255);
    local c1 = lerpColor(from, to, 0.33);
    local c2 = lerpColor(from, to, 0.66);
    
    for i = 1, 15 do
      fill(from);
      quad(
        random(-40, 220), random(height),
        random(-40, 220), random(height),
        random(-40, 220), random(height),
        random(-40, 220), random(height)
      );
      fill(c1);
      quad(
        random(140, 380), random(height),
        random(140, 380), random(height),
        random(140, 380), random(height),
        random(140, 380), random(height)
      );
      fill(c2);
      quad(
        random(320, 580), random(height),
        random(320, 580), random(height),
        random(320, 580), random(height),
        random(320, 580), random(height)
      );
      fill(to);
      quad(
        random(500, 760), random(height),
        random(500, 760), random(height),
        random(500, 760), random(height),
        random(500, 760), random(height)
      );
    end
    --frameRate(5);
end

go {width = 720, height = 400, frameRate=5}
  