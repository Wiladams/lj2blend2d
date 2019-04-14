--[[
    Try out a function that executes on a regular schedule
]]
require("scheduler")

local function ticker()
    print("tick: ", string.format("%3.2f",runningTime()))
end

local function main()
    periodic(1000/10, ticker)
end

run(main)