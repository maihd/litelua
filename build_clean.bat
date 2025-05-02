@echo off

call build_vars.bat

if exist %LITELUA_BUILD_DIR% (
    rmdir /S /Q %LITELUA_BUILD_DIR%
)
