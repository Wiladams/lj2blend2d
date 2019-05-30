package.path = "../?.lua;"..package.path;

local FontMonger = require("FontMonger")

local fm = FontMonger:new()


local function printFaceData(facedata)
    local i = facedata.info

    print("  FACE: ", facedata.face);
    print("       Sizes: ", facedata.sizes, #facedata.sizes);
    print("  postscript: ", i.postscriptName) 
    print("       style: ", i.style)
    print("     stretch: ", i.stretch)
    print("      weight: ", i.weight)
end

local function enumFaces()
for family, subfamily, facedata in fm:faces() do
    print("==================================")
    print(family, subfamily)
    printFaceData(facedata)
end
end

local function test_getface()
    local facedata = fm:getFace("arial", "regular")
    printFaceData(facedata)
end

--enumFaces()
test_getface()
