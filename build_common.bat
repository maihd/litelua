@echo off

set LITELUA_DIR=%~dp0

set LITELUA_OUTPUT=%LITELUA_DIR%\output
set LITELUA_BUILD_DIR=%LITELUA_DIR%\build

if exist %LITELUA_BUILD_DIR% (
    rmdir /S /Q %LITELUA_BUILD_DIR%
)

mkdir %LITELUA_BUILD_DIR%

if not exist %LITELUA_OUTPUT% (
    mkdir %LITELUA_OUTPUT%
)
