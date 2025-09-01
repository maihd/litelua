@echo off

call %~dp0\build_vars.bat

if not exist %LITELUA_DIR%\libs\luajit (
    git clone https://github.com/luajit/luajit.git %LITELUA_DIR%\libs\luajit --recursive --depth=1
)

if not exist %LITELUA_DIR%\libs\luau (
    git clone https://github.com/luau-lang/luau.git %LITELUA_DIR%\libs\luau --recursive --depth=1
)