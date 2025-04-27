# LiteLua
Simple library to wrap multiple Lua runtimes (Lua, LuaJIT, Luau).
Mainly created for LiteFX. Written in C11, mordern C code.


## Features
- Support multi Lua dialects, runtime: Lua, LuaJIT, Luau.
- Prebuilt Lua runtimes to help faster integrate to existing C/C++ projects. Merge multi library files to single one.
- Easy add extensions. This library also have Lua52, Lua53 extensions already for LuaJIT.
- Quality of tools: Debugging, Profiler.
- One place of all runtime docs to work with Lua runtime.
- No changes in the Lua C API code.
- Easy bindings to other languages.
- Out of scope features: OOP/C++ class bindings. But you can use existing project like Sol with LiteLua.
- (Considering) Using Luau with C without compile C code in .cpp files.


## Design philosophy
- One simple API to work lua bindings. Easy embedding to exist projects.
- Focused on simplicity, low files.
- Written in C11, modern C code, good and easy custom io/memory management.
- Focused on the runtime parts, not the C API, so when your application using Luau, need compiling code with C++ compiler.
- Focused on simple, well-docs functions, clear names. And keep its low.


## Building
Currently only work on Windows. Because Mai Lite Editor focused to using on Windows (Game developer).
When building completed, result contains in `output` folder, the library file have already packed with runtime.
No need to build your application with Lua runtime library.
- Build LuaJIT: `build_litelua_luajit.bat`
- Build Luau: `build_litelua_luau.bat`


## Showcases
- LiteFX (Backbone of Mai Lite Editor)
- Raylib Luau bindings
- BeefyMoon library for working with Lua on Beef applications


## Library licenses
Find in `libs` folders.


## Meta
- Version: v0.0.1-dev
- License: Unlicense
- Copyright: MaiHD @ 2025
