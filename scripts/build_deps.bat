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
set VS2026_DEV="C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\VsDevCmd.bat"

if exist %VS2022_DEV% (
    echo Using VS2022 to build LuaJIT

    if "%VSCMD_VER%" equ "" (
        echo Setting up VS2022 devenv with VsDevCmd.bat
        call %VS2022_DEV% 
    )

    echo Building LuaJIT by running msvcbuild.bat
    pushd src
    call msvcbuild.bat lua52compat static
    popd
) else if exist %VS2026_DEV% (
    echo Using VS2026 to build LuaJIT

    if "%VSCMD_VER%" equ "" (
        echo Setting up VS2026 devenv with VsDevCmd.bat
        call %VS2026_DEV% 
    )

    echo Building LuaJIT by running msvcbuild.bat
    pushd src
    call msvcbuild.bat lua52compat static
    popd
) else (
    make CC=clang %LUAJIT_TARGET_SYSTEM%
)

if not exist include (
    mkdir include
)

xcopy src\lua.h include /D /Y /Q
xcopy src\lualib.h include /D /Y /Q
xcopy src\lauxlib.h include /D /Y /Q
xcopy src\luaconf.h include /D /Y /Q

if not exist %LUAJIT_PREBUILT_FOLDER% (
    mkdir %LUAJIT_PREBUILT_FOLDER%
)

xcopy src\lua51.lib %LUAJIT_PREBUILT_FOLDER% /D /Y /Q
rename %LUAJIT_PREBUILT_FOLDER%\lua51.lib lua51_static.lib

popd

:: Build Luau
pushd %LITELUA_DIR%\libs\luau

cmake -B build -GNinja

cmake --build build

if not exist include (
    mkdir include
)

xcopy VM\include\lua.h include /D /Y /Q
xcopy VM\include\lualib.h include /D /Y /Q
xcopy VM\include\luaconf.h include /D /Y /Q
xcopy CodeGen\include\luacodegen.h include /D /Y /Q
xcopy Compiler\include\luacode.h include /D /Y /Q

if not exist %LUAU_PREBUILT_FOLDER% (
    mkdir %LUAU_PREBUILT_FOLDER%
)

xcopy build\Luau.*.lib %LUAJIT_PREBUILT_FOLDER% /D /Y /Q

popd