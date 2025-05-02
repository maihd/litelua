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

// @impl(maihd): Luau's litelua_create_state_luau
static lua_State* litelua_create_state_luau(const LiteLuaGC* gc)
{
    if (gc && gc->alloc)
    {
        return lua_newstate(gc->alloc, gc->user_data);
    }

    return luaL_newstate();
}


// @impl(maihd): Luau's litelua_destroy_state_luau
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
LiteLuaResult litelua_load_string(LiteLua* context, const char* str, size_t len)
{
    int ret = litelua_load_string_luau(context, str, len);
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
        size_t len;
        const char* str = (const char*)context->io.load_file(context->io.user_data, path, path_len, &len);

        int ret = litelua_load_string_luau(context, str, len);

        context->io.unload_file_data(context->io.user_data, (void*)str, len);

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
        LiteLuaResult result = {
            LiteLuaError_UnableToLoadFile,
            "IO load_file is null",
            false
        };
        return result;
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

