@echo off

call build_clean.bat
call build_common.bat

set LITELUA_LUAU_FOLDER=%LITELUA_DIR%\libs\luau-0.671
set LITELUA_LUAU_INCLUDE=%LITELUA_LUAU_FOLDER%\prebuilt\include
:: set LITELUA_LUAU_LIBRARY=%LITELUA_LUAU_FOLDER%\prebuilt\x64\Luau.Compiler.lib %LITELUA_LUAU_FOLDER%\prebuilt\x64\Luau.VM.lib
set LITELUA_LUAU_OUTPUT=%LITELUA_OUTPUT%\litelua_luau_0.671

set LITELUA_LUAU_COMPILE_OPTIONS=^
    -std=c11 ^
    -target x86_64-pc-windows-msvc ^
    -DLITELUA_LUAU_CORE="<lua.h>" ^
    -DLITELUA_LUAU_LIBS="<lualib.h>" ^
    -DLITELUA_LUAU_CODE="<luacode.h>" ^
    -DLITELUA_USING_LUAU=1 ^
    -D_CRT_SECURE_NO_WARNINGS ^
    -I%LITELUA_LUAU_INCLUDE%

:: Building library

clang -c src\litelua_luau.c -o %LITELUA_BUILD_DIR%\litelua_luau.obj %LITELUA_LUAU_COMPILE_OPTIONS%

llvm-ar x %LITELUA_LUAU_FOLDER%\prebuilt\x64\Luau.Config.lib --output %LITELUA_BUILD_DIR%
llvm-ar x %LITELUA_LUAU_FOLDER%\prebuilt\x64\Luau.Require.lib --output %LITELUA_BUILD_DIR%
llvm-ar x %LITELUA_LUAU_FOLDER%\prebuilt\x64\Luau.RequireNavigator.lib --output %LITELUA_BUILD_DIR%
llvm-ar x %LITELUA_LUAU_FOLDER%\prebuilt\x64\Luau.Compiler.lib --output %LITELUA_BUILD_DIR%
llvm-ar x %LITELUA_LUAU_FOLDER%\prebuilt\x64\Luau.Ast.lib --output %LITELUA_BUILD_DIR%
llvm-ar x %LITELUA_LUAU_FOLDER%\prebuilt\x64\Luau.VM.lib --output %LITELUA_BUILD_DIR%

llvm-ar rc %LITELUA_BUILD_DIR%\litelua_luau.lib %LITELUA_BUILD_DIR%\*.obj

:: Copy output files

if not exist %LITELUA_LUAU_OUTPUT% (
    mkdir %LITELUA_LUAU_OUTPUT%
)

if not exist %LITELUA_LUAU_OUTPUT%\include (
    mkdir %LITELUA_LUAU_OUTPUT%\include
)

if not exist %LITELUA_LUAU_OUTPUT%\prebuilt (
    mkdir %LITELUA_LUAU_OUTPUT%\prebuilt
)

if not exist %LITELUA_LUAU_OUTPUT%\prebuilt\x64 (
    mkdir %LITELUA_LUAU_OUTPUT%\prebuilt\x64
)

xcopy %LITELUA_LUAU_INCLUDE% %LITELUA_LUAU_OUTPUT%\include /D /E /Y /Q

xcopy %LITELUA_BUILD_DIR%\litelua_luau.lib %LITELUA_LUAU_OUTPUT%\prebuilt\x64 /D /E /Y /Q
