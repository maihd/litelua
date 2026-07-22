package lua_lightuserdata

import "base:runtime"
import "core:c"
import "core:fmt"
import lua "vendor:lua/5.2"

lua_print_x :: proc "c" (state: ^lua.State) -> c.int {
    x_ptr := transmute(^int)lua.topointer(state, -1)

    context = runtime.default_context()
    fmt.printfln("[lua_print_x] Print x call from lua. x = %v", x_ptr^)
    
    return 0
}

main :: proc() {
    state := lua.L_newstate()
    defer lua.close(state)

    lua.L_openlibs(state)

    funcs := []lua.L_Reg{
        { "print_x", lua_print_x },
        { nil, nil }
    }
    lua.L_newlib(state, funcs)
    lua.setglobal(state, "lib")

    x: int = 10

    lua.pushlightuserdata(state, &x)
    lua.setglobal(state, "x")

    if err := lua.L_dostring(state, "print('Hellope!', x); lib.print_x(x)"); err != 0 {
        errstrlen: c.size_t
        errstrbuf := lua.L_tostring(state, 1, &errstrlen)
        errstrslice := (cast([^]u8)errstrbuf)[:errstrlen]
        errstr := string(errstrslice)

        fmt.printfln("Error: %s", errstr)

        // Pop error from the stack
        lua.pop(state, 1)
    }

    fmt.printfln("x address = %p", &x)
}