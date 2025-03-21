/// litelua_tests_common.c

// C function to be called from Lua code (both in Luau and LuaJIT)
// @note(maihd): Luau and LuaJIT have no differences in how to write C function
int f_add(lua_State* L)
{
    // Get the two arguments from the Lua stack
    double a = lua_tonumber(L, 1); // First argument
    double b = lua_tonumber(L, 2); // Second argument

    // Perform the addition
    double result = a + b;

    // Push the result back to the Lua stack
    lua_pushnumber(L, result);

    // Return 1 (number of results returned to Lua)
    return 1;
}

//! EOF

