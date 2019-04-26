package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local bor, band = bit.bor, bit.band

local b2d = require("blend2d.blend2d")
local blerror = require("blerror")

local BL_FILE_OPEN_SHARE_READ = 0x10000000  -- no worky
local BL_FILE_OPEN_READ = 0x00000001;       -- worky

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


local function test_class()
    local f = BLFile()
    print("f:open(): ", f:open("texture.jpeg", BL_FILE_OPEN_READ))
    print("f:size(): ", f:size())
    print("f:seek(100): ", f:seek(100))

    local buff = ffi.new("uint8_t[100]")
    print("f:read(100): ", f:read(buff, 100))
    
    
    print("f:close(): ", f:close())
end

local function test_API()
    local f = ffi.new("BLFile")
end

local function test_readfonts()
    for _,fontname in ipairs(fontFiles) do
        local  f = BLFile()
        local fullName = fontDir..fontname
        --success, err = f:open(fullName, bor(BL_FILE_OPEN_READ, BL_FILE_OPEN_SHARE_READ))
        local success, err = f:open(fullName, bor(BL_FILE_OPEN_READ))
        print("open: ", fullName, success, err)
        if success then
            f:close()
        else
            print("ERROR: ", blerror[err])
        end
    end
end

--test_class()
--test_API()
test_readfonts()