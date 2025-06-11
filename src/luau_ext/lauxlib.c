#include "lauxlib.h"


void luaL_setmetatable(lua_State *L, const char *tname)
{
    lua_getfield(L, LUA_REGISTRYINDEX, tname);
    lua_setmetatable(L, -2);
}

//! EOF

