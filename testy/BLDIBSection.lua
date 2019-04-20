--[[
        BLDIBSection

        The BLDIBSection is a bridge between blend2d and GDI.  A GDI 
        DIBSection is created, and the data pointer and format are 
        used to create a BLImageCore object, which can be
        used by blend2d.

        This allows us to draw into the DIB section using either 
        GDI or blend2d.  When using it from the blend2d side, you can 
        then display results on the GDI side using simple GDI bitmap
        display operations.
--]]
local ffi = require("ffi")
local C = ffi.C 

local bit = require("bit")
local bnot = bit.bnot;
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift
    
require("blend2d.blend2d")
    
local function GetAlignedByteCount(width, bitsperpixel, alignment)
    local bytesperpixel = bitsperpixel / 8;
    return band((width * bytesperpixel + (alignment - 1)), bnot(alignment - 1));
end
    
    
local BLDIBSection = {}
setmetatable(BLDIBSection, {
        __call = function(self, ...)
            return self:new(...)
        end;
    
        --__index = DeviceContext;
})
local BLDIBSection_mt = {
    __index = BLDIBSection;
}
    
    
function BLDIBSection.new(self, params)
    local obj = params or {}
    
    obj.width = obj.width or 1
    obj.height = obj.height or 1
    obj.bitsPerPixel =  32;
    obj.alignment =  4;
    
    obj.bytesPerRow = GetAlignedByteCount(obj.width, 32, 4)
    
    local info = ffi.new("BITMAPINFO")
    info.bmiHeader.biSize = ffi.sizeof("BITMAPINFOHEADER");
    info.bmiHeader.biWidth = obj.width;
    info.bmiHeader.biHeight = -obj.height;	-- top-down DIB Section
    info.bmiHeader.biPlanes = 1;
    info.bmiHeader.biBitCount = 32;
    info.bmiHeader.biSizeImage = obj.bytesPerRow * obj.height;
    info.bmiHeader.biClrImportant = 0;
    info.bmiHeader.biClrUsed = 0;
    info.bmiHeader.biCompression = C.BI_RGB;
    
    obj.info = info;
    
    local pixelP = ffi.new("void *[1]")
    obj.Handle = C.CreateDIBSection(nil,
            info,
            C.DIB_RGB_COLORS,
            pixelP,
            nil,
            0);
    
    --print("BLDIBSection Handle: ", obj.Handle)
    obj.pixelData = {
        data = pixelP[0];
        size = info.bmiHeader.biSizeImage;
    }

    
    -- create the BLImage to go with it

    local dataPtr = obj.pixelData.data;
    local stride = obj.bytesPerRow;
    local destroyFunc = nil
    local destroyData = nil;
    -- MUST use the PRGB32 in order for SRC_OVER operations to work correctly
    local img, err = BLImage(obj.width, obj.height, C.BL_FORMAT_PRGB32, dataPtr, stride, destroyFunc, destroyData);
    --local img, err = BLImage(obj.width, obj.height, C.BL_FORMAT_XRGB32, dataPtr, stride, destroyFunc, destroyData);

     obj.Image = img;

    setmetatable(obj, BLDIBSection_mt)
    
    return obj;
end


return BLDIBSection
    