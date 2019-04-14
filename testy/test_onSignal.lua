package.path = "../?.lua;"..package.path;

require("scheduler")

local function whenBigSignal(params)
    print("onBigSignal: ", params)
    yield();
end




local function main()
    on("count", whenBigSignal)

    signalAll("count", 1);
    yield();

    signalAll("count", 2);
    yield();
end

run(main)

print("after run")