package.path = "../?.lua;"..package.path;

require("scheduler")


print("StopWatch: ", StopWatch)
local st = StopWatch();

for i=1,1000 do
    print(i)
end

print("seconds: ", st:seconds())