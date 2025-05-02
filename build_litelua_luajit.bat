@echo off

call build_clean.bat
call build_common.bat

set LITELUA_LUAJIT_FOLDER=%LITELUA_DIR%\libs\luajit_2.1.0-rolling_04302025
set LITELUA_LUAJIT_INCLUDE=%LITELUA_LUAJIT_FOLDER%\include
set LITELUA_LUAJIT_LIBRARY=%LITELUA_LUAJIT_FOLDER%\prebuilt\x64\lua51_static.lib
set LITELUA_LUAJIT_OUTPUT=%LITELUA_OUTPUT%\litelua_luajit_2.1.0-rolling_04302025

set LITELUA_LUAJIT_COMPILE_OPTIONS=^
    -std=c11 ^
    -target x86_64-pc-windows-msvc ^
    -DLITELUA_LUA_CORE="<lua.h>" ^
    -DLITELUA_LUA_LIBS="<lualib.h>" ^
    -DLITELUA_LUA_XLIBS="<lauxlib.h>" ^
    -DLITELUA_USING_LUAJIT=1 ^
    -I%LITELUA_LUAJIT_INCLUDE%

:: Building library

clang -c src\litelua_luajit.c -o %LITELUA_BUILD_DIR%\litelua_luajit.obj %LITELUA_LUAJIT_COMPILE_OPTIONS%

llvm-ar x %LITELUA_LUAJIT_LIBRARY% --output %LITELUA_BUILD_DIR%

llvm-ar rc %LITELUA_BUILD_DIR%\litelua_luajit.lib %LITELUA_BUILD_DIR%\*.obj

:: Copy output files

if not exist %LITELUA_LUAJIT_OUTPUT% (
    mkdir %LITELUA_LUAJIT_OUTPUT%
)

if not exist %LITELUA_LUAJIT_OUTPUT%\include (
    mkdir %LITELUA_LUAJIT_OUTPUT%\include
)

if not exist %LITELUA_LUAJIT_OUTPUT%\prebuilt (
    mkdir %LITELUA_LUAJIT_OUTPUT%\prebuilt
)

if not exist %LITELUA_LUAJIT_OUTPUT%\prebuilt\x64 (
    mkdir %LITELUA_LUAJIT_OUTPUT%\prebuilt\x64
)

xcopy %LITELUA_LUAJIT_INCLUDE% %LITELUA_LUAJIT_OUTPUT%\include /D /E /Y /Q

xcopy %LITELUA_BUILD_DIR%\litelua_luajit.lib %LITELUA_LUAJIT_OUTPUT%\prebuilt\x64 /D /E /Y /Q
