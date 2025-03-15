Check list for good Luau perf:
- turn on safe-env
- make sure imports are resolved
- disable GS option on MSVC
- compile Luau with clang
- use native vecs
- if you can afford, run full GC in background thread
- avoid `lua_pushcfunction` at runtime
- profile, profile, profile!
