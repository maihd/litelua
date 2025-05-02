// Use LiteLua as C library
#include "src/litelua.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Import common functions
#include "litelua_tests_common.c"

static void* test_alloc(void* user_data, void* old_ptr, size_t old_size, size_t new_size);

int main()
{
    printf("LiteLua v0.0.1-dev Luau Tests\n");

    LiteLuaIO lua_io = {0};
    LiteLuaGC lua_gc = {
        .user_data = NULL,
        .alloc = test_alloc
    };

    LiteLua lua_context = litelua_create(&lua_io, &lua_gc);

    // Compile options for Luau
    lua_context.compile_options = (lua_CompileOptions){
        0
    };

    // Binding C function to Luau runtime (without needed to know how Luau do it)
    litelua_bind_func(&lua_context, "add", 0, f_add);

    printf("Running code...\n");
    const char* code = "print(\"Hello world\")\nprint(add(2, 3))";
    LiteLuaResult result = litelua_execute(&lua_context, code, strlen(code));
    if (!result.success)
    {
        fprintf(stderr, "Lua error: %s\n", result.message);
        return 1;
    }

    litelua_destroy(&lua_context);
    return 0;
}


void* test_alloc(void* user_data, void* old_ptr, size_t old_size, size_t new_size)
{
    (void)user_data;
    (void)old_size;

    if (new_size == 0 && old_ptr != NULL)
    {
        free(old_ptr);
        return NULL;
    }

    return realloc(old_ptr, new_size);
}

//! EOF

