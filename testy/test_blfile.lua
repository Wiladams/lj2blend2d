package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local b2d = require("blend2d.blend2d")

local BL_FILE_OPEN_SHARE_READ = 0x10000000  -- no worky
local BL_FILE_OPEN_READ = 0x00000001;       -- worky

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

test_class()
--test_API()