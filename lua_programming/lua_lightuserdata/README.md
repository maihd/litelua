# Using Lua LightUserdata

## Why avoid full userdata
- Full userdata is just a table wrap with underneath pointer
- Full userdata as a table still have metatable
- Access method is slow (pointer chasing: full userdata -> metatable -> function call)
- It's heap allocated
- If you need to get data from C (host side), host side need to allocated the table that wrap userdata, and set metatable into the object. This is costly!
- Full userdata is Lua heap allocated, so it must collect by GC, so we cannot control the lifetime
- We cannot control location of memory that allocated on heap, that mean cache misses may occur

## Advantages for light userdata
- Just store as pointer
- No allocation
- Can trick as number or id
- Your bindings are flat, no need to create constructor and destructor
- Your bindings are flat, so we can do simple codegen base on Odin parser

## Disadvantages
- Store as pointer, so it's inherit all problems of pointer
- Have no type

## Tips
- Avoid fulluserdata and lightuserdata
- Use id, best when the data is more frequently create/destroy
- If you want use lightuserdata, make a hash table to check if object is valid or not
- Management lifetime is hard, but can do if we have clear rule
- If you have used allocator, check pointer in the range of memory pool

## Additional resources
- https://bitsquid.blogspot.com/2011/06/lightweight-lua-bindings.html