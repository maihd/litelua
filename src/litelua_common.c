/// LiteLua v0.0.1-dev
/// Copyright: MaiHD @ 2025"


// @impl(maihd): litelua_create
LiteLua litelua_create(const LiteLuaIO* io, const LiteLuaGC* gc)
{
    LiteLua context = {0};

    context.io      = *io;
    context.gc      = *gc;

    #if defined(LITELUA_USING_LUAJIT) || defined(LITELUA_USING_LUA)
    context.L       = litelua_create_state_luajit();
    #elif defined(LITELUA_USING_LUAU)
    context.L       = litelua_create_state_luau();
    #else
    #error Unsupported Lua Runtime
    #endif

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
        #if defined(LITELUA_USING_LUAJIT) || defined(LITELUA_USING_LUA)
        litelua_destroy_state_luajit(context->L);
        #elif defined(LITELUA_USING_LUAU)
        litelua_destroy_state_luau(context->L);
        #else
        #error Unsupported Lua Runtime
        #endif

        context->L = NULL;
    }
}


// @impl(maihd): litelua_execute
LiteLuaResult litelua_execute(LiteLua* context, const char* str, size_t len)
{
    if (!context || !context->L)
    {
        // @todo(maihd): convert to LITELUA_DEBUG(...)
        fprintf(stderr, "Invalid Lua context\n");

        LiteLuaResult result = {
            LiteLuaError_InvalidState,
            "Invalid Lua State",
            false
        };
        return result;
    }

    LiteLuaResult result = litelua_load_string(context, str, len);
    if (!result.success)
    {
        // fprintf(stderr, "Failed to load Lua code: %s\n", lua_tostring(context->L, -1));
        fprintf(stderr, "Failed to load Lua code: %s\n", result.message); // @todo(maihd): convert to LITELUA_DEBUG(...)
        return result;
    }

    lua_call(context->L, 0, 0);

    result.error    = LiteLuaError_None;
    result.message  = "Success";
    result.success  = true;
    return result;
}


// @impl(maihd): litelua_execute_safe
LiteLuaResult litelua_execute_safe(LiteLua* context, const char* str, size_t len)
{
    if (!context || !context->L)
    {
        // @todo(maihd): convert to LITELUA_DEBUG(...)
        fprintf(stderr, "Invalid Lua context\n");

        LiteLuaResult result = {
            LiteLuaError_InvalidState,
            "Invalid Lua State",
            false
        };
        return result;
    }

    LiteLuaResult result = litelua_load_string(context, str, len);
    if (!result.success)
    {
        // fprintf(stderr, "Failed to load Lua code: %s\n", lua_tostring(context->L, -1));
        fprintf(stderr, "Failed to load Lua code: %s\n", result.message); // @todo(maihd): convert to LITELUA_DEBUG(...)
        return result;
    }

    int ret = lua_pcall(context->L, 0, 0, 0);
    if (ret != 0)
    {
        const char* message = lua_tostring(context->L, -1);
        fprintf(stderr, "Failed to run Lua code: %s\n", message); // @todo(maihd): convert to LITELUA_DEBUG(...)
        
        result.error    = LiteLuaError_ExecuteFailure;
        result.message  = message;
        result.success  = false;
        return result;
    }

    result.error    = LiteLuaError_None;
    result.message  = "Success";
    result.success  = true;
    return result;
}


// @impl(maihd): litelua_bind_func
LiteLuaResult litelua_bind_func(LiteLua* context, const char* name, size_t len, lua_CFunction func)
{
    if (!context || !context->L)
    {
        fprintf(stderr, "Invalid Lua context\n");
        LiteLuaResult result = {
            LiteLuaError_InvalidState,
            "Invalid Lua State",
            false
        };
        return result;
    }

    luaL_Reg reg = { name, func };
    luaL_register(context->L, "_G", &reg);

    LiteLuaResult result;
    result.error    = LiteLuaError_None;
    result.message  = "Success";
    result.success  = true;
    return result;
}


// @impl(maihd): litelua_bind_module
LiteLuaResult litelua_bind_module(LiteLua* context, const char* name, size_t len, luaL_Reg* funcs, size_t count)
{
    if (!context || !context->L)
    {
        fprintf(stderr, "Invalid Lua context\n");
        LiteLuaResult result = {
            LiteLuaError_InvalidState,
            "Invalid Lua State",
            false
        };
        return result;
    }

    for (int i = 0; i < count; i++)
    {
        luaL_register(context->L, name, &funcs[i]);
    }

    LiteLuaResult result;
    result.error    = LiteLuaError_None;
    result.message  = "Success";
    result.success  = true;
    return result;
}


//! EOF

