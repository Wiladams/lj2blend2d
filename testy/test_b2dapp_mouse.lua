package.path = "../?.lua;"..package.path;

require("b2dapp")

function setup()
    print("SETUP")
end


function mouseMoved()
    print("   MOVED: ", mouseX, mouseY)
end

function mouseDragged()
    print("DRAGGING: ", mouseX, mouseY)
end


go()