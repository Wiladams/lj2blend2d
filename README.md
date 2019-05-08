# lj2blend2d
LuaJIT binding to blend2d graphics library

https://blend2d.com

Blend2d is a relatively new kid on the block in terms of 2D graphics libraries.
The authors claim a number of innovations which make it at least as competitive
as skia, cairo, Anti Grain, Freetype, and the like.  One of the key novelties is a
JIT compiled rasterization pipeline.

The library has a 'C' and 'C++' interfaces.  It's fairly straightforward in that regard.
Once you get used to it, very similar to Cairo graphics, if you're familiar with that. You have a 
drawing context which maintains some drawing attribute state, and you execute various immediate
mode drawing operations after changing some bit of state.

The code in this library provides a layered approach to accessing the various functions of the
blend2d library.  The primary binding can be found in the blend2d directory.  There are two 
files of interest there.  The first is blend2d_ffi.lua  This single file alone provides the
basic blend2d binding.  If you want to access the raw C functions and need no further help, 
this is the most rudimentary file to use.  It returns a reference to the loaded library, so 
you can just get going:

```lua
local ffi = require("ffi")
local C = ffi.C

local blapi = require("blend2d.blend2d_ffi")
local bResult = blapi.blContextInit(ctx)

local image = ffi.new("struct BLImageCore")
local bResult = blapi.blImageInitAs(image, 640, 480, C.BL_FORMAT_PRGB32)

-- create a context initialized to the image
local ctx = ffi.new("struct BLContextCore")
local options = ffi.new("struct BLContextCreateInfo")
local bResult = blapi.blContextInitAs(ctx, image, options)

-- draw something
local rect = ffi.new("struct BLRectI", {10, 10, 100, 100});
bResult = blapi.blContextFillRectI(ctx, const BLRectI* rect) ;
```

You can spruce this up a bit with some simple typedef declarations

```lua
BLContext = ffi.typeof("struct BLContextCore")
BLRectI = ffi.typeof("struct BLRectI")
BLImage = ffi.typeof("struct BLImageCore")
```

That will eliminate the clunky usage of the 'ffi.new(...)' stuff, and make it look more like what you would actually do in C code with stack based variables.

These typeof conveniences are provided in a second layer of access which can be found in the blend2d.blend2d.lua file.  If you do it this way:

```lua
local blapi = require("blend2d.blend2d")
local img = BLImage(640, 480)
local ctx = BLContext(img)

ctx:fillRectI(BLRectI(10,10,100,100))
```

You will be a lot happier.

This is what's provided in the basic bindings.  If you want to go even further down the rabbit hole of LuaJIT convenience, you can take a look at the various object interfaces provided in the testy directory.  Of particular note is the DrawingContext.lua file, which provides a lot of convenience for state changing and gives you a Processing like drawing interface to most of the functions.  This makes fairly quick work of doing simple graphics drawing.


All of the 'getting-started' samples from the blend2d samples repo are replicated here using the simplified binding interfaces.

https://github.com/blend2d/bl-samples

Here is an example of the first 'getting-started' in its entirety, from the test directory.

```lua
package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 


local b2d = require("blend2d.blend2d")

local function main()
  local img = BLImage(480, 480)
  local ctx, err = BLContext(img)

  -- Clear the image.
  ctx:setCompOp(C.BL_COMP_OP_SRC_COPY);
  ctx:fillAll();

  -- Fill some path.
  local path = BLPath();
  path:moveTo(26, 31);
  path:cubicTo(642, 132, 587, -136, 25, 464);
  path:cubicTo(882, 404, 144, 267, 27, 31);


  ctx:setCompOp(C.BL_COMP_OP_SRC_OVER);
  ctx:setFillStyle(BLRgba32(0xFFFFFFFF));
  ctx:fillPath(path);

  -- Detach the rendering context from `img`.
  ctx:finish();

  BLImageCodec("BMP"):writeImageToFile(img, "output/bl-getting-started-1.bmp")
end

main()
```

It looks fairly similar to the C++ interface, and feels just as convenient.

At this point, if you want to use the most basic ffi style of binding, it is complete, and located in a single file 'blend2d_ffi'.  If you want a little more convenience, you can use the blend2d.lua file (probably most typical).  If you want to go on quite a journey, you can look at all the things in the testy directory.


The roadmap:

- Track The changes in blend2d as it moves from beta to release
- Continue adding conveniences to the blend2d.lua interface
- Work on the DrawingContext and other tidbits in the testy directory
- Create as many interestesting use cases/tests as possible to find any bugs
- Have fun
