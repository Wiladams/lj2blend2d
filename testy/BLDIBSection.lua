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
})

    
function BLDIBSection.createDIBSection(self, params)
    if not params then
        return false, "must specify some parameters"
    end

    if not params.width or not params.height then
        return false, "must specify width and height"
    end

    local obj = {
        width = params.width,
        height = params.height;
        bitsPerPixel = params.bitsPerPixel or 32;
        alignment = params.alignment or 4;
    }
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

    local pPixels = ffi.new("void *[1]")
    obj.GDIHandle = C.CreateDIBSection(nil,
            info,
            C.DIB_RGB_COLORS,
            pPixels,
            nil,
            0);
    
    --print("BLDIBSection Handle: ", obj.Handle)
    obj.pixelData = {
        data = pPixels[0];
        size = info.bmiHeader.biSizeImage;
    }

    return obj
end

function BLDIBSection.bindBLImage(self, DIB)
    local dataPtr = DIB.pixelData.data;
    local stride = DIB.bytesPerRow;
    local destroyFunc = nil
    local destroyData = nil;
    -- MUST use the PRGB32 in order for SRC_OVER operations to work correctly
    local img, err = BLImage(DIB.width, DIB.height, C.BL_FORMAT_PRGB32, dataPtr, stride, destroyFunc, destroyData);

    return img, err
end

function BLDIBSection.new(self, params)
    local DIB, err = self:createDIBSection(params)
    if not DIB then
        return nil, err
    end

    DIB.DC = C.CreateCompatibleDC(nil)
    C.SelectObject(DIB.DC, DIB.GDIHandle)

    -- bind DIB to BLImage
    local img, err = self:bindBLImage(DIB)

    if not img then
        return nil, err;
    end

    DIB.Image = img;
    
    return DIB;
end


return BLDIBSection
    