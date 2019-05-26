package.path = "../?.lua;"..package.path;

local winman = require("WinMan")
local Slider = require("slider")

local desktopWidth = 1200
local desktopHeight = 768



-- Simple app to put up a window
-- with a graphic embedded
local function app(params)
    local win1 = WMCreateWindow(params)

    local s1 = Slider:new({title = "red", bgColor = color(0xff,0,0), frame={x=20, y=20, width=256, height=20}})
    local s2 = Slider:new({title = "green", bgColor = color(0,0xff,0), frame={x=20, y=44, width=256, height=20}})
    local s3 = Slider:new({title = "blue", bgColor = color(0,0,0xff), frame={x=20, y=68, width=256, height=20}})
    
    win1:add(s1)
    win1:add(s2)
    win1:add(s3)

    win1:show()

    local function handleSliderChange(slider, sig)
        print(slider.title, sig, string.format("%32.f",slider:getPosition()), slider:getValue())
    end

    on(s1, handleSliderChange)
    on(s2, handleSliderChange)
    on(s3, handleSliderChange)


---[[
    while true do 
        win1:draw()
        yield()
    end
--]]
end


local function startup()
    spawn(app, {frame = {x=4, y=4, width=640, height=280}})
end

winman {width = desktopWidth, height=desktopHeight, startup = startup, frameRate=30}