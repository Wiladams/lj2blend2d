package.path = "../?.lua;"..package.path;

--[[
    This is a generic file to try out various things ad-hoc
    meant to try and throw away
]]
local winman = require("WinMan")

local AngleIndicator = require("AngleIndicator")

local maths = require("maths")
local radians = maths.radians
local degrees = maths.degrees
local map = maths.map
local cos = math.cos
local sin = math.sin

local desktopWidth = 1200
local desktopHeight = 1080




local function app(params)
    local win1 = WMCreateWindow(params)
    win1.value = 0;
    win1.radius = 100;


    function win1.draw(self, ctx)
        ctx = ctx or self:getDrawingContext()
        ctx:clear()
    
        local segmentRads = radians(360/12)

        ctx:textAlign(MIDDLE, BASELINE)
        ctx:fill(255)
    
        -- x = r cos theta
        -- y = r sin theta
    
        local angle = segmentRads - radians(-90)
        local r = self.radius - 30
        local cx = 200
        local cy = 200

        for i=1,12 do
            local x = cx + (r * cos(angle))
            local y = cy + (r * sin(angle))
            print(x,y)
            ctx:text(tostring(i), x, y)
            angle = angle + segmentRads;
        end
    end



    win1:show()

    local function drawproc()
        win1:draw()
    end

    periodic(1000/10, drawproc)
--[[
    while true do 
        win1:draw()
        yield()
    end
--]]
end


local function startup()
    spawn(app, {frame = {x=40, y=40, width=400, height=400}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup, frameRate=30}
