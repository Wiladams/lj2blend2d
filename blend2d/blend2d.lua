--[[
// [Blend2D]
// 2D Vector Graphics Powered by a JIT Compiler.
//
// [License]
// ZLIB - See LICENSE.md file in the package.
--]]

--[[
// This is a public header file designed to be used by Blend2D users.
// It includes all the necessary files to use Blend2D library from C
// and C++ and its the only header that is guaranteed to stay.
//
// Never include directly header files placed in "blend2d" directory.
// Headers that end with "_p" suffix are private and should never be
// included as they are not part of public API.
--]]

local ffi = require("ffi")


require("blend2d.blapi");
require("blend2d.blarray");
require("blend2d.blbitarray");
require("blend2d.blcontext");
require("blend2d.blfilesystem");
require("blend2d.blfont");
require("blend2d.blfontdefs");
require("blend2d.blformat");
require("blend2d.blgeometry");
require("blend2d.blglyphbuffer");
require("blend2d.blgradient");
require("blend2d.blimage");
require("blend2d.blmatrix");
require("blend2d.blpath");
require("blend2d.blpattern");
require("blend2d.blpixelconverter");
require("blend2d.blrandom");
require("blend2d.blregion");
require("blend2d.blrgba");
require("blend2d.blruntime");
require("blend2d.blstring");
require("blend2d.blvariant");



-- blcontext types
BLContextCreateOptions = ffi.new("struct BLContextCreateOptions")
BLContextCookie = ffi.typeof("struct BLContextCookie")
BLContextHints = ffi.typeof("struct BLContextHints")
BLContextState = ffi.typeof("struct BLContextState")
BLContext = ffi.typeof("struct BLContextCore")


return ffi.load("blend2d")