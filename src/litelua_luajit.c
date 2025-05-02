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

// @impl(maihd): Luau's litelua_load_string
LiteLuaResult litelua_load_string(LiteLua* context, const char* str, size_t len)
{
    int ret = litelua_load_string_luajit(context, str, len);
    if (ret != 0)
    {
        const char* message = lua_tostring(context->L, -1);

        LiteLuaResult result = {
            LiteLuaError_CompileFailure,
            message,
            false
        };
        return result;
    }
    else
    {
        LiteLuaResult result = {
            LiteLuaError_None,
            "Success",
            true
        };
        return result;
    }
}


// @impl(maihd): Luau's litelua_load_file
LiteLuaResult litelua_load_file(LiteLua* context, const char* path, size_t path_len)
{
    if (context->io.load_file)
    {
        const char* str = path;
        const size_t len = path_len;

        int ret = litelua_load_string_luajit(context, str, len);
        if (ret != 0)
        {
            const char* message = lua_tostring(context->L, -1);

            LiteLuaResult result = {
                LiteLuaError_CompileFailure,
                message,
                false
            };
            return result;
        }
    }
    else
    {
        int ret = luaL_loadfile(context->L, path);
        if (ret != 0)
        {
            const char* message = lua_tostring(context->L, -1);

            LiteLuaResult result = {
                LiteLuaError_CompileFailure,
                message,
                false
            };
            return result;
        }
    }

    LiteLuaResult result = {
        LiteLuaError_None,
        "Success",
        true
    };
    return result;
}

// Using UnityBuild to reuse implementation
#include "litelua_common.c"


//! EOF

