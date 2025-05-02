// Use LiteLua as C library
#include "src/litelua.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Import common functions
#include "litelua_tests_common.c"

static void*    test_alloc(void* user_data, void* old_ptr, size_t old_size, size_t new_size);

static void*    load_file(void* user_data, const char* path, size_t path_len, size_t* file_size);
static void     unload_file_data(void* user_data, void* data, size_t data_size);

int main()
{
    printf("LiteLua v0.0.1-dev Luau Tests\n");

    LiteLuaIO lua_io = {
        .user_data = NULL,
        .load_file = load_file,
        .unload_file_data = unload_file_data
    };

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

    printf("Executing chunk code...\n");
    const char* code = "print(\"Hello world\")\nprint(add(2, 3))";
    LiteLuaResult result = litelua_execute(&lua_context, code, strlen(code));
    if (!result.success)
    {
        fprintf(stderr, "Lua error: %s\n", result.message);
        return 1;
    }

    printf("Executing chunk code from file...\n");
    result = litelua_execute_file(&lua_context, "tests/tests.lua", 16);
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


void* load_file(void* user_data, const char* path, size_t path_len, size_t* out_file_size)
{
    FILE* file = fopen(path, "rb");
    if (file)
    {
        fseek(file, 0, SEEK_END);
        size_t size = (size_t)ftell(file);
        fseek(file, 0, SEEK_SET);

        void* data = malloc(size);
        fread(data, 1, size, file);
        *out_file_size = size;

        return data;
    }

    return NULL;
}


void unload_file_data(void* user_data, void* data, size_t data_size)
{
    free(data);
}

//! EOF

