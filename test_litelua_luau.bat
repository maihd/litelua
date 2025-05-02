@echo off

call build_litelua_luau.bat

set LITELUA_LUAU_TEST_EXE=%LITELUA_BUILD_DIR%\litelua_tests_luau.exe

clang litelua_tests_luau.c ^
    -o %LITELUA_LUAU_TEST_EXE% ^
    %LITELUA_LUAU_COMPILE_OPTIONS% ^
    %LITELUA_LUAU_OUTPUT%\prebuilt\x64\litelua_luau.lib

%LITELUA_LUAU_TEST_EXE%

del %LITELUA_LUAU_TEST_EXE%
