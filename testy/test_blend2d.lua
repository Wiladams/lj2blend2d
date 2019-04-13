package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local b2d = require("blend2d.blend2d")

print("blend2d: ", b2d)

if not b2d then
    return false;
end


print("Init(): ", b2d.blRuntimeInit());
print("Shutdown(): ", b2d.blRuntimeShutdown());
