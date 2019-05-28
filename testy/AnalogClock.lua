
local maths = require("maths")
local radians = maths.radians
local degrees = maths.degrees
local map = maths.map
local cos = math.cos
local sin = math.sin
local clamp = maths.clamp

local AnalogClock = {}
local AnalogClock_mt = {
    __index = AnalogClock
}

function AnalogClock.getPreferredSize(self)
    return {width = 200, height = 200}
end

function AnalogClock.new(self, obj)
    local size = self:getPreferredSize()

    obj = obj or {
        frame={x=0, y=0, width=size.width, height=size.height};
    }

    obj.value = obj.value or 0

    obj.frame.width = obj.frame.width or size.width;
    obj.frame.height = obj.frame.height or size.height;
    
    obj.centerX = obj.frame.width/2;
    obj.centerY = obj.frame.height/2;
    obj.radius = obj.radius or obj.centerX;

    obj.overshootAmount = radians(1.25);
    obj.overshootRemaining = 0;
    obj.recoveryIncrement = radians(1.0);

    --obj.drivenExternally = obj.drivenExternally or false


    obj.time = obj.time or {hour=10, min=15, sec=35};

    setmetatable(obj, AnalogClock_mt)

    return obj
end



function AnalogClock.getFrame(self)
    return self.frame
end



function AnalogClock.drawSecondTickmarks(self, ctx)
    ctx:save()

    local segmentRads = radians(360/60)
    
    ctx:strokeWidth(2)
    ctx:stroke(30)

    for i=0,59 do
        ctx:line(self.radius-10,0,self.radius-4, 0)
        ctx:rotate(segmentRads)
    end

    ctx:restore()
end

--[[
    This needs to draw outside the context of other 
    rotations and translations so we don't get
    mixed up in the various transformations.

    Ideally, we'd be able to use the current rotation
    and translation, and counter rotate the text
    along the way.
]]
function AnalogClock.drawHourNumbers(self, ctx)
    ctx:save()

    ctx:textAlign(MIDDLE, BASELINE)
    ctx:fill(30)

--[[
    local segmentRads = radians(360/12)
    local cumulativeRadians = 0
    
    for i=1,12 do
        ctx:rotate(segmentRads)

        ctx:save()
        ctx:translate(self.radius-34, 0)
        ctx:rotate(cumulativeRadians-radians(90))
        ctx:text(tostring(i), 0,0)
        ctx:restore()

        cumulativeRadians = cumulativeRadians + segmentRads
    end
--]]

---[[
    local segmentRads = radians(360/12)
    local angle = segmentRads - radians(90)
    local r = self.radius - 34

    for i=1,12 do
        --local x = self.centerX + (r * cos(angle))
        --local y = self.centerY + (r * sin(angle))

        ctx:text(tostring(i), self.centerX + (r * cos(angle)), self.centerY + (r * sin(angle)))
        angle = angle + segmentRads;
    end
--]]

    ctx:restore()
end

function AnalogClock.drawHourTickmarks(self, ctx)
    ctx:save()

    local segmentRads = radians(360/12)
    
    ctx:strokeWidth(4)
    ctx:stroke(30)

    for i=0,11 do
        ctx:line(self.radius-20,0,self.radius-4, 0)
        ctx:rotate(segmentRads)
    end

    ctx:restore()
end

function AnalogClock.drawHourHand(self, ctx)
    ctx:save()

    -- Do the rotation thing
    local minuteContribution = radians(self.time.min/60 * 30)
    local hourRads = radians(map(self.time.hour%12, 0, 11, 0, 330)) + minuteContribution
    ctx:rotate(hourRads)

    -- Draw the indicator line
    ctx:strokeWidth(4)
    ctx:stroke(30)
    ctx:line(-4,0,self.centerX-40, 0)
    
    ctx:restore()
end

function AnalogClock.drawMinuteHand(self, ctx)
    ctx:save()

    -- Do the rotation thing
    local minuteRads = radians(map(self.time.min, 0, 59, 0, 354))
    ctx:rotate(minuteRads)

    -- Draw the indicator line
    ctx:strokeWidth(4)
    ctx:stroke(30)
    ctx:line(-2,0,self.centerX-20, 0)
    
    ctx:restore()
end

function AnalogClock.drawSecondsHand(self, ctx)
    ctx:save()

    -- Do the rotation thing
    --ctx:translate(self.centerX, self.centerY)
    local secRads = radians(map(self.time.sec, 0, 59, 0, 354))
    if self.time.sec ~= self.lastSec then
        self.overshootRemaining = self.overshootAmount
        self.lastSec = self.time.sec
    end

    secRads = secRads + self.overshootRemaining

    self.overshootRemaining = clamp(self.overshootRemaining - self.recoveryIncrement, 0, self.overshootAmount);


    ctx:rotate(secRads)

    -- Draw the indicator line
    ctx:strokeWidth(1)
    ctx:stroke(255,0,0)
    ctx:line(-8,0,self.radius-10, 0)
    
    ctx:restore()
 end

function AnalogClock.draw(self, ctx)

    -- if self driven, get our own time
    if not self.drivenExternally then
        self.time = os.date("*t")
    end

    -- fill background
    ctx:ellipseMode(RADIUS);
    ctx:stroke(255);
    ctx:strokeWidth(2);
    ctx:fill(210,210,210);
    --ctx:fill(0xe2,0x84,0x30);
    ctx:circle(self.centerX, self.centerY, self.frame.width/2)
    ctx:fill(240)
    ctx:circle(self.centerX, self.centerY, 6)

    ctx:save();

    -- draw hour numbers before we get all rotated
    self:drawHourNumbers(ctx)

    -- orient so 0 angle is at 12-oclock
    -- and do all angle oriented drawing within the
    -- context of this save/restore
    ctx:translate(self.centerX, self.centerY)
    ctx:rotate(radians(-90))
    
    self:drawHourTickmarks(ctx)
    self:drawSecondTickmarks(ctx)

   --  self:drawHourNumbers(ctx)


    self:drawHourHand(ctx);
    self:drawMinuteHand(ctx);
    self:drawSecondsHand(ctx);

    ctx:restore()
end

return AnalogClock
