-- References
-- https://blog.wooting.nl/the-ultimate-guide-to-keyboard-layouts-and-form-factors/
-- https://www.google.com/search?q=windows-keyboard-60-keys&source=lnms&tbm=isch&sa=X&ved=0ahUKEwj-6569vP3hAhUCSX0KHT-sBzYQ_AUIDigB&biw=1174&bih=687#imgdii=OjnWmMVZmV6xpM:&imgrc=TCvZ-CdnC1S44M:
-- to building keyboard layout graphics
local ffi = require("ffi")
local C = ffi.C 

local vkeys = require("vkeys")
local Gradient = require("Gradient")
local keylayout = require("ansikeylayout")

local function insetRect(rrect, cx, cy)
    local dx = cx/2
    local dy = cy/2

    return BLRoundRect(rrect.x+dx,rrect.y+dy,rrect.w-cx, rrect.h-cy, rrect.rx, rrect.ry)
end


local GKeyboard = {}
GKeyboard.__index = GKeyboard

function GKeyboard.new(self, obj)
    local obj = obj or {}
    obj.unit = obj.unit or 40
    obj.keysState = ffi.new("BYTE[256]")
    obj.showKeyState = true;
    obj.linear = Gradient.LinearGradient({
        values = {0, 0, 0, self.unit};
        stops = {
          {offset = 0, uint32 = 0xFFFFFFFF},
          {offset = 1, uint32 = 0xFF1F7FFF}
        }
      });

    setmetatable(obj, GKeyboard)

    self.keyFrames = keylayout

    return obj;
end

function GKeyboard.nowShowKeystate(self)
    self.showKeyState = false;
end

function GKeyboard.showKeystate(self)
    self.showKeyState = true;
end

function GKeyboard.drawKeystates(self, ctx)
    -- go through the states
    -- for the ones that are ~= 0
    -- show them as pressed
end

function GKeyboard.draw(self, ctx)
    -- draw a standard bottom row
    ctx:fill(127)
    ctx:stroke(10)
    ctx:strokeWidth(1)

    local xmargin = 4
    local xgap = 2
    local rowoffset = 4
    local ygap = 2

    ctx:textAlign(MIDDLE, MIDDLE)
    ctx:textSize(12);

    for _, key in ipairs(self.keyFrames) do
        local rrect = BLRoundRect(key.frame.x,key.frame.y,key.frame.width, key.frame.height, 3, 3)
        local crect = insetRect(rrect,self.unit*0.30,self.unit*0.30)

        ctx:fill(127)
        --ctx:setFillStyle(self.linear)
        ctx:fillRoundRect(rrect)    
        ctx:strokeRoundRect(rrect)

        ctx:fill(255, 126)
        ctx:fillRoundRect(crect)

        ctx:fill(0)
        ctx:text(key.caption, key.frame.x+key.frame.width/2, key.frame.y+key.frame.height/2)
    end
end

return GKeyboard
