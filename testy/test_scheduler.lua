require("scheduler")

local function counter(count, name)
    for i=1,count do
        print(name, i)
        yield();
    end

    signalAll("quit")

end

local function quitting()
    print("quitting")
    halt();
end



local function main()

    on('quit', quitting)
    
    spawn(counter, 10, "counter-10")
    spawn(counter, 20, "counter-20")

    while true do
        yield();
    end
end

run(main)