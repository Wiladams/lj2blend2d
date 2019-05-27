package.path = "../?.lua;"..package.path;

local winman = require("WinMan")

local RGBExplorer = require("RGBExplorer")

local desktopWidth = 1200
local desktopHeight = 768




local function app(params)
    local win1 = WMCreateWindow(params)

    local rgbExp = RGBExplorer:new()
    rgbExp:moveTo(10,10)
    
    win1:add(rgbExp)

    win1:show()

    local function handleSliderChange(slider, sig)
        print(slider.title, sig, string.format("%32.f",slider:getPosition()), slider:getValue())
    end

---[[
    while true do 
        win1:draw()
        yield()
    end
--]]
end


local function startup()
    spawn(app, {frame = {x=4, y=4, width=640, height=480}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup, frameRate=30}