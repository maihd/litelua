/// LiteLua v0.0.1-dev
/// Luau implementation
/// Copyright: MaiHD @ 2025

#include "litelua.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

// Luau-specific implementations
#if !defined(LITELUA_USING_LUAU)
#error "Unsupported Lua runtime"
#endif

static lua_State* litelua_create_state_luau(void)
{
    return luaL_newstate();
}


static void litelua_destroy_state_luau(lua_State* L)
{
    lua_close(L);
}


// @impl(maihd): Luau's litelua_load_string_luau
static int litelua_load_string_luau(LiteLua* context, const char* str, size_t len)
{
    size_t code_len;
    char* code = luau_compile(str, len, &context->compile_options, &code_len);
    if (code == NULL)
    {
        fprintf(stderr, "Compile error: %s\n", code);
        return -1;
    }

    int ret = luau_load(context->L, "temp", code, code_len, 0);

    free(code);

    return ret;
}

// @impl(maihd): Luau's litelua_load_string
LiteLuaResult   litelua_load_string(LiteLua* context, const char* str, size_t len)
{

}


// @impl(maihd): Luau's litelua_load_file
LiteLuaResult litelua_load_file(LiteLua* context, const char* str, size_t len)
{
    
}

// Using UnityBuild to reuse implementation
#include "litelua_common.c"


//! EOF

