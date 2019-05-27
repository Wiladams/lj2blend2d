--[[
    Try out a function that executes on a regular schedule
    and cancel it.
]]
require("scheduler")
local functor = require("functor")

local function ticker(name)
    print("tick: ", name, string.format("%3.2f",runningTime()))
end

local function printDict(dict, title)
    print("== DICT: ", title)

    for k,v in pairs(dict) do
        print(k,v)
    end
end

local function main()
    local t1 = periodic(500, functor(ticker, "t-1"))
    local t2 = periodic(1000, functor(ticker, "t-2"))

    -- cancel t1 after two seconds
    delay(2000, function() t1:cancel() end)

    -- stop the whole thing after 10 seconds
    delay(5000, function() print("HALTING") halt() end)
end

run(main)