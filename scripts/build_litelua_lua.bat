@echo off

call %~dp0\build_clean.bat
call %~dp0\build_common.bat

set LITELUA_LUA_FOLDER=%LITELUA_DIR%\libs\lua-5.2.4
set LITELUA_LUA_INCLUDE=%LITELUA_LUA_FOLDER%\include
set LITELUA_LUA_LIBRARY=%LITELUA_LUA_FOLDER%\prebuilt\win_x64\lua52_static.lib
set LITELUA_LUA_OUTPUT=%LITELUA_OUTPUT%\litelua_lua

set LITELUA_LUA_COMPILE_OPTIONS=^
    -std=c11 ^
    -target x86_64-pc-windows-msvc ^
    -DLITELUA_LUA_CORE="<lua.h>" ^
    -DLITELUA_LUA_LIBS="<lualib.h>" ^
    -DLITELUA_LUA_XLIBS="<lauxlib.h>" ^
    -DLITELUA_USING_LUA=1 ^
    -I%LITELUA_LUA_INCLUDE%

:: Building library

clang -c "%LITELUA_DIR%\src\litelua_luajit.c" -o "%LITELUA_BUILD_DIR%\litelua_lua.obj" %LITELUA_LUA_COMPILE_OPTIONS%

:: Extract obj from LuaJIT.lib
llvm-ar x "%LITELUA_LUA_LIBRARY%" --output "%LITELUA_BUILD_DIR%"

:: Packaging LuaJIT obj and LiteLua obj into one .lib
llvm-ar rc "%LITELUA_BUILD_DIR%\litelua_lua.lib" "%LITELUA_BUILD_DIR%\*.obj"

:: Copy output files

if not exist "%LITELUA_OUTPUT%" (
    mkdir "%LITELUA_OUTPUT%"
)

if not exist "%LITELUA_LUA_OUTPUT%" (
    mkdir "%LITELUA_LUA_OUTPUT%"
)

if not exist "%LITELUA_LUA_OUTPUT%\include" (
    mkdir "%LITELUA_LUA_OUTPUT%\include"
)

if not exist "%LITELUA_LUA_OUTPUT%\prebuilt" (
    mkdir "%LITELUA_LUA_OUTPUT%\prebuilt"
)

if not exist "%LITELUA_LUA_OUTPUT%\prebuilt\win_x64" (
    mkdir "%LITELUA_LUA_OUTPUT%\prebuilt\win_x64"
)

xcopy "%LITELUA_DIR%\src\litelua.h" "%LITELUA_LUA_OUTPUT%\include" /D /E /Y /Q
xcopy "%LITELUA_DIR%\src\litelua_config.h" "%LITELUA_LUA_OUTPUT%\include" /D /E /Y /Q

xcopy "%LITELUA_LUA_INCLUDE%" "%LITELUA_LUA_OUTPUT%\include" /D /E /Y /Q

xcopy "%LITELUA_BUILD_DIR%"\litelua_lua.lib %LITELUA_LUA_OUTPUT%\prebuilt\win_x64 /D /E /Y /Q

rmdir "%LITELUA_LUA_OUTPUT%\include\luau_ext" /Q /S