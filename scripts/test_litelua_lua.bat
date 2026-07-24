@echo off

call %~dp0\build_litelua_lua.bat

set LITELUA_LUA_TEST_EXE=%LITELUA_BUILD_DIR%\litelua_tests_lua.exe

clang tests/litelua_tests_luajit.c ^
    -o %LITELUA_LUA_TEST_EXE% ^
    %LITELUA_LUA_COMPILE_OPTIONS% ^
    -I%LITELUA_LUA_OUTPUT%\include ^
    %LITELUA_LUA_OUTPUT%\prebuilt\win_x64\litelua_lua.lib

%LITELUA_LUA_TEST_EXE%

del %LITELUA_LUA_TEST_EXE%
