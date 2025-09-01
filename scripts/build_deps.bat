@echo off

:: Download deps
call %~dp0\download_deps.bat

:: Checking current OS
set LUAJIT_TARGET_SYSTEM=""
set LUAJIT_PREBUILT_FOLDER="prebuilt/win_x64"

set LUAU_TARGET_SYSTEM=""
set LUAU_PREBUILT_FOLDER="prebuilt/win_x64"

:: Build LuaJIT
pushd %LITELUA_DIR%\libs\luajit

set VS2022_DEV="C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
if exist %VS2022_DEV% (
    if not "%VSCMD_VER%" equ "" (
        call %VS2022_DEV% 
    )

    pushd src
    call msvcbuild.bat static
    popd
) else (
    make CC=clang %LUAJIT_TARGET_SYSTEM%
)

if not exist include (
    mkdir include
)

xcopy src/lua.h include /D /Y /Q
xcopy src/lualib.h include /D /Y /Q
xcopy src/lauxlib.h include /D /Y /Q
xcopy src/luaconf.h include /D /Y /Q

if not exist %LUAJIT_PREBUILT_FOLDER% (
    mkdir %LUAJIT_PREBUILT_FOLDER%
)

xcopy src/lua51.lib %LUAJIT_PREBUILT_FOLDER% /D /Y /Q
rename %LUAJIT_PREBUILT_FOLDER%\lua51.lib lua51_static.lib

popd

:: Build Luau
pushd %LITELUA_DIR%\libs\luau

cmake -B build -GNinja

cmake --build build

if not exist include (
    mkdir include
)

cp VM/include/lua.h include
cp VM/include/lualib.h include
cp VM/include/luaconf.h include
cp CodeGen/include/luacodegen.h include
cp Compiler/include/luacode.h include

if not exist %LUAU_PREBUILT_FOLDER% (
    mkdir %LUAU_PREBUILT_FOLDER%
)

cp build/Luau.*.lib %LUAJIT_PREBUILT_FOLDER%

popd