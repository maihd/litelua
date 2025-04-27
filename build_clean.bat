@echo off

if exist %LITELUA_BUILD_DIR% (
    rmdir /S /Q %LITELUA_BUILD_DIR%
)
