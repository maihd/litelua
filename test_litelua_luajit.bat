@echo off

call build_litelua_luajit.bat

set LITELUA_LUAJIT_TEST_EXE=%LITELUA_BUILD_DIR%\litelua_tests_luajit.exe

clang litelua_tests_luajit.c ^
    -o %LITELUA_LUAJIT_TEST_EXE% ^
    %LITELUA_LUAJIT_COMPILE_OPTIONS% ^
    %LITELUA_LUAJIT_OUTPUT%\prebuilt\x64\litelua_luajit.lib

%LITELUA_LUAJIT_TEST_EXE%

del %LITELUA_LUAJIT_TEST_EXE%
