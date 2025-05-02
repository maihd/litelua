@echo off

call build_vars.bat

if exist %LITELUA_BUILD_DIR% (
    rmdir /S /Q %LITELUA_BUILD_DIR%
)

mkdir %LITELUA_BUILD_DIR%

if not exist %LITELUA_OUTPUT% (
    mkdir %LITELUA_OUTPUT%
)
