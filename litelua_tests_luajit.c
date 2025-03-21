#define LITELUA_LUA_CORE    <lua.h>
#define LITELUA_LUA_LIBS    <lualib.h>
#define LITELUA_LUA_XLIBS   <lauxlib.h>

#define LITELUA_USING_LUAJIT 1
#define LITELUA_IMPLEMENTATION
#include "litelua.h"

#include <stdio.h>
#include <string.h>


#include "litelua_tests_common.c"


int main()
{
    printf("LiteLua v0.0.1-dev Tests LuaJIT\n");

    LiteLuaIO lua_io = {0};
    LiteLuaGC lua_gc = {0};

    LiteLuaFuncs lua_funcs = litelua_load_funcs();
    LiteLua lua_context = litelua_create(&lua_funcs, &lua_io, &lua_gc);

    // Binding C function to LuaJIT runtime (without needed to know how LuaJIT do it)
    litelua_bind_func(&lua_context, "add", 0, f_add);

    const char* code = "print(\"Hello world\")\nprint(add(2, 3))";
    int error = litelua_execute(&lua_context, code, strlen(code));
    if (error != 0)
    {
        fprintf(stderr, "Lua error: %s\n", lua_tostring(lua_context.L, -1));
        return 1;
    }

    litelua_destroy(&lua_context);
    return 0;
}

//! EOF

