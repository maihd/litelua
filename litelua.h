/// LiteLuaFuncs v0.0.1-dev
/// Copyright: MaiHD @ 2025

#pragma once

// -----------------------------------
// Include header files
// -----------------------------------

#include <stdint.h>
#include <stdbool.h>

#ifndef LITELUA_LUA_CORE
#define LITELUA_LUA_CORE <lua/lua.h>
#endif

#ifndef LITELUA_LUA_LIBS
#define LITELUA_LUA_LIBS <lua/lualib.h>
#endif

#ifndef LITELUA_LUA_XLIBS
#define LITELUA_LUA_XLIBS <lua/lauxlib.h>
#endif

#include LITELUA_LUA_CORE
#include LITELUA_LUA_LIBS
#include LITELUA_LUA_XLIBS

#ifndef LITELUA_API
#define LITELUA_API
#endif

// #if defined(LITELUA_USING_LUAJIT) || defined(LITELUA_USING_LUA)

// #elif defined(LITELUA_USING_LUAU)

// #endif


// -----------------------------------
// Types
// -----------------------------------

typedef struct LiteLuaFuncs
{
    lua_State*  (*create_state)(void);
    void        (*destroy_state)(lua_State* L);
    int         (*load_string)(lua_State* L, const char* str, size_t len);
} LiteLuaFuncs;


typedef struct LiteLua
{
    lua_State*      L;
    LiteLuaFuncs    funcs;
} LiteLua;


// -----------------------------------
// Runtime management
// -----------------------------------

LITELUA_API LiteLuaFuncs    litelua_load_funcs(void);

LITELUA_API LiteLua         litelua_create(const LiteLuaFuncs* funcs);
LITELUA_API void            litelua_destroy(LiteLua* context);

LITELUA_API int             litelua_execute(LiteLua* context, const char* str, size_t len);
LITELUA_API int             litelua_execute_safe(LiteLua* context, const char* str, size_t len);

LITELUA_API int             litelua_bind_func(LiteLua* context, const char* name, size_t len, lua_CFunction func);
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
lua_State* litelua_create_state_luajit(void)
{
    return luaL_newstate();
}

void litelua_destroy_state_luajit(lua_State* L)
{
    lua_close(L);
}

int litelua_load_string_luajit(lua_State* L, const char* str, size_t len)
{
    return luaL_loadstring(L, str);
}

// Luau-specific implementations
#elif defined(LITELUA_USING_LUAU)
lua_State* litelua_create_state_luau(void)
{
    return luaL_newstate();
}

void litelua_destroy_state_luau(lua_State* L)
{
    lua_close(L);
}

int litelua_load_string_luau(lua_State* L, const char* str, size_t len)
{
    lua_CompileOptions opts = {0};

    size_t code_len;
    char* code = luau_compile(str, len, &opts, &code_len);
    if (code == NULL)
    {
        fprintf(stderr, "Compile error: %s\n", code);
        return -1;
    }

    int ret = luau_load(L, "temp", code, code_len, 0);

    free(code);

    return ret;
}

#else
#error "Unsupported Lua runtime"
#endif


LiteLuaFuncs litelua_load_funcs(void)
{
    LiteLuaFuncs lite_lua = {0};

#if defined(LITELUA_USING_LUAJIT)
    lite_lua.create_state = litelua_create_state_luajit;
    lite_lua.destroy_state = litelua_destroy_state_luajit;
    lite_lua.load_string = litelua_load_string_luajit;
#elif defined(LITELUA_USING_LUAU)
    lite_lua.create_state = litelua_create_state_luau;
    lite_lua.destroy_state = litelua_destroy_state_luau;
    lite_lua.load_string = litelua_load_string_luau;
#endif

    return lite_lua;
}


LiteLua litelua_create(const LiteLuaFuncs* funcs)
{
    LiteLua context = {0};
    context.funcs = *funcs;
    context.L = funcs->create_state();

    if (!context.L)
    {
        fprintf(stderr, "Failed to create Lua state\n");
    }

    luaL_openlibs(context.L);

    return context;
}


void litelua_destroy(LiteLua* context)
{
    if (context && context->L)
    {
        context->funcs.destroy_state(context->L);
        context->L = NULL;
    }
}


int litelua_execute(LiteLua* context, const char* str, size_t len)
{
    if (!context || !context->L)
    {
        fprintf(stderr, "Invalid Lua context\n");
        return -1;
    }

    if (context->funcs.load_string(context->L, str, len) != 0)
    {
        fprintf(stderr, "Failed to load Lua code: %s\n", lua_tostring(context->L, -1));
        return -1;
    }

    printf("Call function\n");
    int ret = lua_pcall(context->L, 0, 0, 0);
    if (ret != 0)
    {
        fprintf(stderr, "Failed to run Lua code: %s\n", lua_tostring(context->L, -1));
        return ret;
    }

    return ret;
}


int litelua_execute_safe(LiteLua* context, const char* str, size_t len)
{
    return -1;
}


int litelua_bind_func(LiteLua* context, const char* name, size_t len, lua_CFunction func)
{
    return -1;
}


int litelua_bind_module(LiteLua* context, const char* name, size_t len, luaL_Reg* funcs, size_t count)
{
    return -1;
}


#endif

//! EOF

