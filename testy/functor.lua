--[[
    This is a convenient construct that allows you to pass an 
    object instance method to something that expects a function.

    That something will call this functor as usual, and the functor
    ensures the right instance of the object actually receives the 
    method call.

    You can use it like this.

    on(win, functor(win.onClose, win))

    The 'on()' function waits for a signal, and then 
    executes the given function.  Since we've passed in a functor
    which wraps the win.onClose function, that specific instance
    of the function will be called.
--]]
local function functor(func, obj)
    return function(...)
        return func(obj, ...)
    end
end

return functor