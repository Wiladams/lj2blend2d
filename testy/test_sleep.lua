require("scheduler")
local functor = require("functor")


local function main()
    sleep(2000)
    print("SLEPT (2.0): ", runningTime())
end

run(main)