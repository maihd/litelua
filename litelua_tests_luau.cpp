#define LITELUA_LUA_CORE    <lua.h>
#define LITELUA_LUA_LIBS    <lualib.h>
#define LITELUA_LUA_XLIBS   <luacode.h>

#define LITELUA_USING_LUAU 1
#define LITELUA_IMPLEMENTATION
#include "litelua.h"

#include <stdio.h>
#include <string.h>

int main()
{
    printf("LiteLua v0.0.1-dev Luau Tests\n");

    // lua_State* L = luaL_newstate();
    LiteLuaFuncs lua_funcs = litelua_load_funcs();
    LiteLua lua_context = litelua_create(&lua_funcs);

    printf("Running code...\n");
    const char* code = "print(\"Hello world\")\nprint(\"Hello world 2\")";
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

