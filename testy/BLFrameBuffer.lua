--[[
        BLFrameBuffer

        A blend2d image that is meant to be blt to a Win32 device context.
        When the image is created, the attendant bitmapinfo is created at
        the same time.

        As this is meant to be used for a blt operation, we use RGB instead
        of an RGBA format, to avoid hassles with GDI rendering an alpha channel
--]]
local ffi = require("ffi")
local C = ffi.C 

local bit = require("bit")
local bnot = bit.bnot;
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift
    
    
    
local function GetAlignedByteCount(width, bitsperpixel, alignment)
    local bytesperpixel = bitsperpixel / 8;
    return band((width * bytesperpixel + (alignment - 1)), bnot(alignment - 1));
end
    
    
local BLFrameBuffer = {}
setmetatable(BLFrameBuffer, {
        __call = function(self, ...)
            return self:new(...)
        end;
    
        __index = DeviceContext;
})
local BLFrameBuffer_mt = {
    __index = BLFrameBuffer;
}
    
    
function BLFrameBuffer.init(self, params)
    local obj = params or {}
    
    obj.width = obj.width or 1
    obj.height = obj.height or 1
    obj.bitsPerPixel = obj.bitsPerPixel or 24;
    obj.alignment = obj.alignment or 4;
    
    obj.bytesPerRow = GetAlignedByteCount(obj.width, obj.bitsPerPixel, obj.alignment)
    
    local info = ffi.new("BITMAPINFO")
    info.bmiHeader.biSize = ffi.sizeof("BITMAPINFOHEADER");
    info.bmiHeader.biWidth = obj.width;
    info.bmiHeader.biHeight = -obj.height;	-- top-down DIB Section
    info.bmiHeader.biPlanes = 1;
    info.bmiHeader.biBitCount = obj.bitsPerPixel;
    info.bmiHeader.biSizeImage = obj.bytesPerRow * obj.height;
    info.bmiHeader.biClrImportant = 0;
    info.bmiHeader.biClrUsed = 0;
    info.bmiHeader.biCompression = C.BI_RGB;
    
    obj.info = info;
    
    local pixelP = ffi.new("void *[1]")
    obj.DIBHandle = C.CreateDIBSection(nil,
            info,
            ffi.C.DIB_RGB_COLORS,
            pixelP,
            nil,
            0);
            
    --print("GDIDIBSection Handle: ", obj.Handle)
    obj.pixelData = {
        data = pixelP[0];
        size = info.bmiHeader.biSizeImage;
    }
    
    -- Create a memory device context, either compatible
    -- with something, or just compatible with DISPLAY
    obj.DC = DeviceContext:CreateForMemory(obj.compatDC)
    
    -- select the object into the context so we're ready to draw
    local selected = obj.DC:SelectObject(obj.DIBHandle)
    
    setmetatable(obj, GDISurface_mt)
    
    return obj;
end
    
function BLFrameBuffer.new(self, ...)
    return self:init(...)
end
    

    
return BLFrameBuffer
    