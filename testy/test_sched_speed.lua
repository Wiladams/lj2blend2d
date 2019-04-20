--[[
    A simple test to figure out what the raw switching cost is for
    the scheduler.  Set a high frame rate until you're satisfied it's
    fast enough for your needs.

    With a framerate of 1,000, we are able to switch between
    tasks with only 1ms spent within the tasks.  If you're trying 
    to maintain something like 30 frames per second, it's likely
    that your own tasks will be taking up the bulk of the time, not
    the raw task switch cost.
]]
local sched = require("scheduler")

local frameCount = 0
local frameRate = 1000

local function counter()
    frameCount = frameCount+1
    if frameCount == 5*frameRate then
        halt()
    end
end

local function main()
    periodic(1000/frameRate, counter)
end

run(main)

print("Run Time: ", runningTime())
print("Fixed Rate: ", frameRate)
print("Frame Count: ", frameCount)
print("Runtime Rate: ", frameCount/runningTime())
