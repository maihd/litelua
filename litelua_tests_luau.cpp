// Use LiteLua as C library
#include "src/litelua.h"

#include <stdio.h>
#include <string.h>

// Import common functions
#include "litelua_tests_common.c"


int main()
{
    printf("LiteLua v0.0.1-dev Luau Tests\n");

    LiteLuaIO lua_io = {0};
    LiteLuaGC lua_gc = {0};

    LiteLuaFuncs lua_funcs = litelua_load_funcs();
    LiteLua lua_context = litelua_create(&lua_funcs, &lua_io, &lua_gc);

    // Binding C function to Luau runtime (without needed to know how Luau do it)
    litelua_bind_func(&lua_context, "add", 0, f_add);

    printf("Running code...\n");
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

