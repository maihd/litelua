/// LiteLuaFuncs v0.0.1-dev
/// Copyright: MaiHD @ 2025

#pragma once

// -----------------------------------
// Include header files
// -----------------------------------

#include <stdint.h>
#include <stdbool.h>

#include "litelua_config.h"


// -----------------------------------
// Types
// -----------------------------------


typedef struct LiteLua LiteLua;


/// Lua runtime functions
typedef struct LiteLuaFuncs
{
    lua_State*  (*create_state)(void);
    void        (*destroy_state)(lua_State* L);
    int         (*load_string)(LiteLua* L, const char* str, size_t len);
} LiteLuaFuncs;


/// IO plugins
typedef struct LiteLuaIO
{
    void*       (*load_file)(const char* path, size_t path_len);
} LiteLuaIO;


/// Memory manager, GC customizations
typedef struct LiteLuaGC
{
    void*       (*alloc)(size_t size);
} LiteLuaGC;


/// Context of LiteLua (Core components)
struct LiteLua
{
    lua_State*          L;

    // Callbacks, modules

    LiteLuaIO           io;
    LiteLuaGC           gc;
    LiteLuaFuncs        funcs;

    // Runtime-based required fields

#if defined(LITELUA_USING_LUAU)
    lua_CompileOptions  compile_options;
#endif
};


/// Error code of LiteLua
typedef enum LiteLuaError
{
    LiteLuaError_None,
    LiteLuaError_InvalidState,
    LiteLuaError_CompileFailure,
} LiteLuaError;


/// Result when do execution
typedef struct LiteLuaResult
{
    LiteLuaError    error;
    const char*     message;
    bool            success;
} LiteLuaResult;


// -----------------------------------
// Runtime management
// -----------------------------------

/// Load funcs of target Lua Runtime
LITELUA_API LiteLuaFuncs    litelua_load_funcs(void);

/// Create LiteLua context base on funcs, io, gc
LITELUA_API LiteLua         litelua_create(const LiteLuaFuncs* funcs, const LiteLuaIO* io, const LiteLuaGC* gc);

/// Destroy LiteLua context, release used memory
LITELUA_API void            litelua_destroy(LiteLua* context);

/// Execute Lua chunk code without checking error, but still checking compile failure
LITELUA_API int             litelua_execute(LiteLua* context, const char* str, size_t len);

/// Execute Lua chunk code with checking error, compile failure
LITELUA_API int             litelua_execute_safe(LiteLua* context, const char* str, size_t len);

/// Binding global C function
LITELUA_API int             litelua_bind_func(LiteLua* context, const char* name, size_t len, lua_CFunction func);

/// Binding global C modules
LITELUA_API int             litelua_bind_module(LiteLua* context, const char* name, size_t len, luaL_Reg* funcs, size_t count);


// -----------------------------------
// Implementation
// -----------------------------------

#ifdef LITELUA_IMPLEMENTATION

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

// LuaJIT-specific implementations
#if defined(LITELUA_USING_LUAJIT)
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


// Luau-specific implementations
#elif defined(LITELUA_USING_LUAU)
static lua_State* litelua_create_state_luau(void)
{
    return luaL_newstate();
}


static void litelua_destroy_state_luau(lua_State* L)
{
    lua_close(L);
}


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


#else
#error "Unsupported Lua runtime"
#endif


// @impl(maihd): litelua_load_funcs
LiteLuaFuncs litelua_load_funcs(void)
{
    LiteLuaFuncs lite_lua   = {0};

#if defined(LITELUA_USING_LUAJIT)
    lite_lua.create_state   = litelua_create_state_luajit;
    lite_lua.destroy_state  = litelua_destroy_state_luajit;
    lite_lua.load_string    = litelua_load_string_luajit;
#elif defined(LITELUA_USING_LUAU)
    lite_lua.create_state   = litelua_create_state_luau;
    lite_lua.destroy_state  = litelua_destroy_state_luau;
    lite_lua.load_string    = litelua_load_string_luau;
#endif

    return lite_lua;
}


// @impl(maihd): litelua_create
LiteLua litelua_create(const LiteLuaFuncs* funcs, const LiteLuaIO* io, const LiteLuaGC* gc)
{
    LiteLua context = {0};

    context.io      = *io;
    context.gc      = *gc;
    context.funcs   = *funcs;

    context.L       = funcs->create_state();

    if (!context.L)
    {
        fprintf(stderr, "Failed to create Lua state\n");
    }

    luaL_openlibs(context.L);

    return context;
}


// @impl(maihd): litelua_destroy
void litelua_destroy(LiteLua* context)
{
    if (context && context->L)
    {
        context->funcs.destroy_state(context->L);
        context->L = NULL;
    }
}


// @impl(maihd): litelua_execute
int litelua_execute(LiteLua* context, const char* str, size_t len)
{
    if (!context || !context->L)
    {
        fprintf(stderr, "Invalid Lua context\n");
        return -1;
    }

    if (context->funcs.load_string(context, str, len) != 0)
    {
        fprintf(stderr, "Failed to load Lua code: %s\n", lua_tostring(context->L, -1));
        return -1;
    }

    int ret = lua_pcall(context->L, 0, 0, 0);
    if (ret != 0)
    {
        fprintf(stderr, "Failed to run Lua code: %s\n", lua_tostring(context->L, -1));
        return ret;
    }

    return ret;
}


// @impl(maihd): litelua_execute_safe
int litelua_execute_safe(LiteLua* context, const char* str, size_t len)
{
    if (!context || !context->L)
    {
        fprintf(stderr, "Invalid Lua context\n");
        return -1;
    }

    if (context->funcs.load_string(context, str, len) != 0)
    {
        fprintf(stderr, "Failed to load Lua code: %s\n", lua_tostring(context->L, -1));
        return -1;
    }

    int ret = lua_pcall(context->L, 0, 0, 0);
    if (ret != 0)
    {
        fprintf(stderr, "Failed to run Lua code: %s\n", lua_tostring(context->L, -1));
        return ret;
    }

    return ret;
}


// @impl(maihd): litelua_bind_func
int litelua_bind_func(LiteLua* context, const char* name, size_t len, lua_CFunction func)
{
    if (context == NULL || context->L == NULL)
    {
        return -1;
    }

    luaL_Reg reg = { name, func };
    luaL_register(context->L, "_G", &reg);
    return 0;
}


// @impl(maihd): litelua_bind_module
int litelua_bind_module(LiteLua* context, const char* name, size_t len, luaL_Reg* funcs, size_t count)
{
    if (context == NULL || context->L == NULL)
    {
        return -1;
    }

    for (int i = 0; i < count; i++)
    {
        luaL_register(context->L, name, &funcs[i]);
    }

    return 0;
}


#endif

//! EOF

