package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

local blapi = require("blend2d.blend2d")
local errors = require("blerror")
local fontDir = "c:\\windows\\fonts\\"

local fontFiles = {
    "alger.ttf",
    "arial.ttf",
    "calibri.ttf",
    "Candara.ttf",
    "comic.ttf",
    "consola.ttf",
    "cour.ttf",
    "times.ttf",
    "timesi.ttf",
    "wingding.ttf",
}


local function createFontFaceFromFile(fileName)
    local obj = ffi.new("struct BLFontFaceCore")

    local bResult = blapi.blFontFaceInit(obj)
    if bResult ~= C.BL_SUCCESS then
        return nil, "failed blFontFaceInit"
    end

    local bResult = blapi.blFontFaceCreateFromFile(obj, fileName) ;

    if bResult ~= C.BL_SUCCESS then
      return nil, bResult 
    end

    return obj;
end;


local function test_fontface(fileName)
    local fullName = fontDir..fileName
    --print("loadFont: ", fullName)

    local font, err = createFontFaceFromFile(fullName)

    if font then return font end

    return false, err
end

local function test_fontloader()
    for _, filename in ipairs(fontFiles) do
        local fullname = fontDir..filename
        local loader, err = BLFontLoader:createFromFile(fullname)
        print("Loader: ", fullname, loader, errors[tonumber(err)])
    end 
end


local function test_errors()
    for k,v in pairs(errors) do
        print(k,v)
    end
end

test_fontloader()
