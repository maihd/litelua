/// LiteLuaFuncs v0.0.1-dev
/// Copyright: MaiHD @ 2025

#include "litelua.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

// LuaJIT-specific implementations
#if !defined(LITELUA_USING_LUAJIT)
#error "Unsupported Lua runtime"
#endif

static lua_State* litelua_create_state_luajit(void)
{
    return luaL_newstate();
}


static void litelua_destroy_state_luajit(lua_State* L)
{
    lua_close(L);
}


static int litelua_load_string_luajit(LiteLua* context, const char* str, size_t len)
{
    return luaL_loadstring(context->L, str);
}

// Using UnityBuild to reuse implementation
#include "litelua_common.c"


//! EOF

