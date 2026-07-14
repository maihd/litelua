# LiteLua
Simple library to wrap multiple Lua runtimes (Lua, LuaJIT, Luau).
Mainly created for LiteFX. Written in C11, mordern C code.


## Features
- Multiple Lua dialects are supported, included runtime: Lua, LuaJIT, Luau.
- Prebuilt Lua runtimes to help faster integrate to existing C/C++ projects. Merge multi library files to single one.
- Thin layer API to support working with multiple Lua runtimes. 
- Easy add extensions. This library also have Lua52, Lua53 extensions already for LuaJIT.
- Quality of tools: Debugging, Profiler.
- Controlling JIT (if supported)
- One place of all runtime docs to work with Lua runtime.
- No changes in the Lua C API code.
- Easy bindings to other languages.
- Out of scope features: OOP/C++ class bindings. But you can use existing project like Sol with LiteLua.
- Using Luau with C without compile C code in .cpp files.


## Design philosophy
- One simple API to work lua bindings. Easy embedding to exist projects.
- Focused on simplicity, low files.
- Written in C11, modern C code, good and easy custom io/memory management.
- Focused on the runtime parts, not the C API.
- Focused on simple, well-docs functions, clear names. And keep its low.
- Only functions that need wrapper are made, otherwise use common functions (Luau and Lua have many common C API).


## Extensions & experiments
- How to management memory with Lua (Memory allocator and GC)
- Sandboxing Lua scripts, some poorman security tricks to make Lua scripts safer
- Lua for pure scripting purpose, using flat data, and procedural programming only
- Lua script performance
- High performance VM tips & tricks (maybe just a collection of articles from internet + examples)
- Hot reloading & development cycles for productivity


## Building
When building completed, result contains in `output` folder, the library file have already packed with runtime.
No need to build your application with Lua runtime library.
- Build LuaJIT: `scripts/build_litelua_luajit.bat`/`scripts/build_litelua_luajit.sh`
- Build Luau: `scripts/build_litelua_luau.bat`/`scripts/build_litelua_luau.sh`

Supported host platforms:
- Windows
- MacOS & Linux (shell scripts)

Supported target platforms (no mobile and embedded):
- Windows
- MacOS
- Linux


## Showcases (imagination projects)
- LiteFX (Backbone of Mai Lite Editor)
- Raylib Luau bindings
- BeefyMoon library for working with Lua on Beef applications


## Library licenses
Find in `libs` folders.


## Meta
- Version: v0.0.3-dev
- License: Unlicense
- Copyright: MaiHD @ 2025-2026
