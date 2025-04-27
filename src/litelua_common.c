/// LiteLua v0.0.1-dev
/// Copyright: MaiHD @ 2025"


// @impl(maihd): litelua_create
LiteLua litelua_create(const LiteLuaIO* io, const LiteLuaGC* gc)
{
    LiteLua context = {0};

    context.io      = *io;
    context.gc      = *gc;

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

    if (litelua_load_string(context, str, len) != 0)
    {
        fprintf(stderr, "Failed to load Lua code: %s\n", lua_tostring(context->L, -1));
        return -1;
    }

    lua_call(context->L, 0, 0, 0);
    return 0;
}


// @impl(maihd): litelua_execute_safe
int litelua_execute_safe(LiteLua* context, const char* str, size_t len)
{
    if (!context || !context->L)
    {
        fprintf(stderr, "Invalid Lua context\n");
        return -1;
    }

    if (litelua_load_string(context, str, len) != 0)
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


//! EOF

