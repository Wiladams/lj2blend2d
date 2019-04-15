local ffi = require("ffi")

ffi.cdef[[
typedef struct tagFoo {
    int size;
} Foo;
]]
Foo = ffi.typeof("Foo")

ffi.metatype(Foo, {
    __index = {
        create = function(self, ...)
            print("creating: ", self)
            return ffi.new(Foo, ...)
        end;
    }
})

Foo:create()
