-- References
-- https://blog.wooting.nl/the-ultimate-guide-to-keyboard-layouts-and-form-factors/
-- https://www.google.com/search?q=windows-keyboard-60-keys&source=lnms&tbm=isch&sa=X&ved=0ahUKEwj-6569vP3hAhUCSX0KHT-sBzYQ_AUIDigB&biw=1174&bih=687#imgdii=OjnWmMVZmV6xpM:&imgrc=TCvZ-CdnC1S44M:
-- to building keyboard layout graphics
local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local band, bor = bit.band, bit.bor

local DrawingContext = require("DrawingContext")
local vkeys = require("vkeys")
local Gradient = require("Gradient")
--local keylayout = require("ansikeylayout")
local keylayout = require("ansikeystrict")



local function insetRect(rrect, cx, cy)
    local dx = cx/2
    local dy = cy/2

    return BLRoundRect(rrect.x+dx,rrect.y+dy,rrect.w-cx, rrect.h-cy, rrect.rx, rrect.ry)
end

-- maybe create a table with vkey as the key value
-- so these lookups aren't quite some linear
local function findVKey(list, value)
    for _, key in ipairs(list) do
        if key.vkey == value then
            return key
        end
    end

    return false;
end


local GKeyboard = {}
GKeyboard.__index = GKeyboard

function GKeyboard.new(self, obj)
    local obj = obj or {}
    obj.unit = obj.unit or 40
    obj.xmargin = 4;
    obj.showKeyState = true;
    
    obj.gradient = Gradient.LinearGradient({
        values = {obj.unit/2, obj.unit/2, obj.unit/2, obj.unit/2};
        stops = {
            {offset = 0.0, uint32 = 0xFF4f4f4f},
            {offset = 1.0, uint32 = 0xFF9f9f9f},
        }
      });

    --[[
    obj.gradient = Gradient.RadialGradient({
        values = {obj.unit/2, obj.unit/2, obj.unit/2, obj.unit/2, obj.unit};
        stops = {
            {offset = 0.0, uint32 = 0xFF4f4f4f},
            {offset = 1.0, uint32 = 0xFF9f9f9f},
--            {offset = 1.0, uint32 = 0xFFCCCCCC},
        }
      });
      --]]

    obj.keyFrames = keylayout
    
    setmetatable(obj, GKeyboard)
    
    -- setup the backingcontext
    local extent = obj:getPreferredSize()

    --obj.backingContext = DrawingContext(extent) 
    --obj:drawNeutral(obj.backingContext)

    return obj;
end

-- get the preferred width and height of keyboard
function GKeyboard.getPreferredSize(self)
    local extent = BLRectI(0,0,0,0)
    for _, key in ipairs(self.keyFrames) do
        local rect = BLRectI(key.frame.x,key.frame.y,key.frame.width, key.frame.height)
        extent = extent + rect
    end

    return {width = extent.w, height = extent.h}
end

function GKeyboard.nowShowKeystate(self)
    self.showKeyState = false;
end

function GKeyboard.showKeystate(self)
    self.showKeyState = true;
end

local KEY_IS_DOWN = 0x8000;

function GKeyboard.drawKeyStates(self, ctx)
    -- first get the state of all the keys
    local lpKeyState = ffi.new("uint8_t[256]")
    local bResult = C.GetKeyboardState(lpKeyState);

    ---[[
    for _, key in ipairs(self.keyFrames) do
        local state = tonumber(band(C.GetAsyncKeyState(key.vkey), 0xffff))
        if band(state, 0xffff) ~= 0 then
            --print(string.format("key: 0x%02x  %10s    state: %02x", key.vkey, tostring(key.caption), state))
            --if band(state, KEY_IS_DOWN) ~= 0 then
            local rrect = BLRoundRect(key.frame.x,key.frame.y,key.frame.width, key.frame.height, 3, 3)
            ctx:fill(0x30, 0x6f)
            ctx:fillRoundRect(rrect)
        end
    end

end



--[[
    Draw the keyboard with no keys pressed to start
]]
function GKeyboard.drawNeutral(self, ctx)
    -- draw a standard bottom row
    ctx:fill(127)
    ctx:stroke(10)
    ctx:strokeWidth(1)


    local xgap = 2
    local rowoffset = 4
    local ygap = 2

    ctx:textAlign(MIDDLE, MIDDLE)
    ctx:textFont("segoe ui")
    ctx:textSize(8);
    for _, key in ipairs(self.keyFrames) do

        local rrect = BLRoundRect(key.frame.x,key.frame.y,key.frame.width, key.frame.height, 3, 3)
        local crect = insetRect(rrect,self.unit*0.30,self.unit*0.30)
        -- need to adjust values of linear gradient
        local cx = key.frame.x + key.frame.width/2;
        local cy = key.frame.y + key.frame.height/2;
        local r = key.frame.height
        --local values = BLRadialGradientValues(cx, cy, cx, cy, r)
        local values = BLLinearGradientValues(cx, cy, cx, key.frame.y+key.frame.height)

        self.gradient:setValues(values)

        --ctx:fill(self.gradient)
        ctx:setFillStyle(self.gradient)

        ctx:fillRoundRect(rrect)    

        --ctx:setFillStyle(BLRgba32(0))
        ctx:fill(0)

        ctx:stroke(0)
        ctx:strokeRoundRect(rrect)
---[[

        ctx:fill(255, 0x6f)
        ctx:fillRoundRect(crect)
--]]
        ctx:fill(0)
        ctx:text(key.caption, key.frame.x+key.frame.width/2, key.frame.y+key.frame.height/2)

    end

end

function GKeyboard.draw(self, ctx)
--[[
    local readyBuff = self.backingContext:getReadyBuffer()
    if readyBuff then
        ctx:blit(readyBuff, self.frame.x, self.frame.y)
    end
--]]

    --ctx:blit(self.backingContext:getReadyBuffer(), self.frame.x, self.frame.y)
    self:drawNeutral(ctx)
    self:drawKeyStates(ctx)
end

return GKeyboard
