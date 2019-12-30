--[=[
    This file exists to turn the .h files of blend2d into the 
    appropriate LuaJIT FFI form.
    
-- first do this
    copy the blend2d.h file into this directory

    copy c:\repos\blendwsp\blend2d\src\blend2d.h .

then
    mkdir blend2d

    copy c:\repos\blendwsp\blend2d\src\blend2d\blapi.h blend2d

    Copy the rest of the interesting header files into that directory
    api.h
    array.h
    bitarray.h
    context.h
    filesystem.h
    font.h
    fontdefs.h
    fontmanager.h
    format.h
    geometry.h
    glyphbuffer.h
    gradient.h
    image.h
    imagecodec.h
    matrix.h
    path.h
    pattern.h
    pixelconverter.h
    random.h
    region.h
    rgba.h
    runtime.h
    string.h
    variant.h
    
-- cl /E blend2d.h > blend2d_ffi.txt

--Then run this file on the resulting blend2d_ffi.txt
-- luajit preproc.lua blend2d_ffi.txt > blend2d_ffi.lua
--
-- look for the line starting: typedef struct BLRange BLRange;
-- and delete everything before that

Put the ffi inclusion at the top of the file
    local ffi = require("ffi")
    ffi.cdef[[

Put the ffi conclusion at the end of the file
    ]]
    return ffi.load("blend2d")


All done!

Of Note:
Endian things are not taken care of, meaning, they default to little-endian
blruntime
blfontdefs
blformat
blrgba
some union/structs are collapsed
--]=]


for line in io.lines("blend2d_ffi.txt") do
    if line ~= "" and line ~= "  " then
        if string.sub(line, 1, 1) ~= '#' then
            if not string.find(line, "__pragma") then
                print(line)
            end
        end
    end
end
