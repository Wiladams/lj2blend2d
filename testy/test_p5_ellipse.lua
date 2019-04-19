package.path = "../?.lua;"..package.path;

require("p5")


function setup()
    --noStroke();
    noLoop();
end
  
function draw() 
    drawCircle(width/2, 360, 6);
end
  
function drawCircle(x, radius, level)

    local tt = floor(126 * level/4.0);
    --print(string.format("color: %d, x = %d, rad = %d, level = %d", tt, x, radius, level))
    fill(tt);
    ellipse(x, height/2, radius*2, radius*2);      
    if(level > 1) then
        level = level - 1;
        drawCircle(x - radius/2, radius/2, level);
        drawCircle(x + radius/2, radius/2, level);
    end
end

go {width = 720, height = 400, title="p5_structure_recursion"}