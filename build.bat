@echo off

:: set LUA_FOLDER=D:\projects\litelua\libs\luajit_2.1.0-beta3
set LUAU_FOLDER=D:\projects\litelua\libs\luau-0.660

:: clang litelua_tests.c -I%LUA_FOLDER%\include %LUA_FOLDER%\prebuilt\x64\lua51_static.lib
clang++ litelua_tests_luau.cpp ^
    -std=c++11 ^
    -target x86_64-pc-windows-msvc ^
    -Xlinker /NODEFAULTLIB:MSVCRT -Xlinker /NODEFAULTLIB:libcmt ^
    -lmsvcrt -lvcruntime ^
    -I%LUAU_FOLDER%\prebuilt\include ^
    %LUAU_FOLDER%\prebuilt\x64\ucrt\Luau.VM.lib ^
    %LUAU_FOLDER%\prebuilt\x64\ucrt\Luau.AST.lib ^
    %LUAU_FOLDER%\prebuilt\x64\ucrt\Luau.Compiler.lib
