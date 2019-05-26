package.path = "../?.lua;"..package.path;

local winman = require("WinMan")
local Slider = require("slider")

local desktopWidth = 1200
local desktopHeight = 768



-- Simple app to put up a window
-- with a graphic embedded
local function app(params)
    local win1 = WMCreateWindow(params)

    local s1 = Slider:new({frame={x=20, y=20, width=320, height=20}})
    
    win1:add(s1)
    win1:show()

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