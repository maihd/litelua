
#include "src/litelua.h"

#include <stdio.h>
#include <string.h>


#include "litelua_tests_common.c"


int main()
{
    printf("LiteLua v0.0.1-dev LuaJIT Tests\n");

    LiteLuaIO lua_io = {0};
    LiteLuaGC lua_gc = {0};

    LiteLua lua_context = litelua_create(&lua_io, &lua_gc);

    // Binding C function to LuaJIT runtime (without needed to know how LuaJIT do it)
    litelua_bind_func(&lua_context, "add", 0, f_add);

    const char* code = "print(\"Hello world\")\nprint(add(2, 3))";
    LiteLuaResult result = litelua_execute(&lua_context, code, strlen(code));
    if (!result.success)
    {
        fprintf(stderr, "Lua error: %s\n", result.message);
        return 1;
    }

    litelua_destroy(&lua_context);
    return 0;
}

//! EOF

