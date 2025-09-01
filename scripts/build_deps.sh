# Download deps
$(dirname "$0")/download_deps.sh

# Checking current OS
if [ "$(uname)" == "Darwin" ]; then
    LUAJIT_TARGET_SYSTEM="MACOSX_DEPLOYMENT_TARGET=14.00"
    LUAJIT_PREBUILT_FOLDER="prebuilt/mac_arm64"

    LUAU_TARGET_SYSTEM=""
    LUAU_PREBUILT_FOLDER="prebuilt/mac_arm64"
else
    LUAJIT_TARGET_SYSTEM=""
    LUAJIT_PREBUILT_FOLDER="prebuilt/linux64" # dont support linux arm now

    LUAU_TARGET_SYSTEM=""
    LUAU_PREBUILT_FOLDER="prebuilt/linux64"
fi

# Build LuaJIT
cd libs/luajit

make CC=clang $LUAJIT_TARGET_SYSTEM

mkdir -p include
cp src/lua.h include
cp src/lualib.h include
cp src/lauxlib.h include
cp src/luaconf.h include

mkdir -p $LUAJIT_PREBUILT_FOLDER
cp src/libluajit.a $LUAJIT_PREBUILT_FOLDER

cd ../..

# Build Luau
cd libs/luau

cmake -B build -GNinja

cmake --build build

mkdir -p include
cp VM/include/lua.h include
cp VM/include/lualib.h include
cp VM/include/luaconf.h include
cp CodeGen/include/luacodegen.h include
cp Compiler/include/luacode.h include

mkdir -p $LUAU_PREBUILT_FOLDER
cp build/libLuau.*.a $LUAJIT_PREBUILT_FOLDER

cd ../..