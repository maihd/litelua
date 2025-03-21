@echo off

set LUAJIT_FOLDER=D:\projects\litelua\libs\luajit_2.1.0-beta3

clang litelua_tests_luajit.c ^
    -o test_luajit.exe ^
    -I%LUAJIT_FOLDER%\include %LUAJIT_FOLDER%\prebuilt\x64\lua51_static.lib

test_luajit.exe
