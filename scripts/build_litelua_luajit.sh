if command -v figlet &> /dev/null; then
    figlet "Building LiteLua LuaJIT"
fi

LITELUA_SCRIPTS_FOLDER=$(dirname "$0")

LITELUA_DIR="$LITELUA_SCRIPTS_FOLDER/.."

LITELUA_OUTPUT="$LITELUA_DIR/output"
LITELUA_BUILD_DIR="$LITELUA_DIR/build"

$LITELUA_SCRIPTS_FOLDER/build_clean.sh
$LITELUA_SCRIPTS_FOLDER/build_common.sh

if [ "$(uname)" == "Darwin" ]; then
    LITELUA_PREBUILT_FOLDER="prebuilt/mac_arm64"
else
    LITELUA_PREBUILT_FOLDER="prebuilt/linux64"
fi

LITELUA_LUAJIT_FOLDER="$LITELUA_DIR/libs/luajit"
LITELUA_LUAJIT_INCLUDE="$LITELUA_LUAJIT_FOLDER/include"
LITELUA_LUAJIT_LIBRARY="$LITELUA_LUAJIT_FOLDER/$LITELUA_PREBUILT_FOLDER/libluajit.a"
LITELUA_LUAJIT_OUTPUT="$LITELUA_OUTPUT/litelua_luajit"

    # -target x86_64-pc-windows-msvc ^
LITELUA_LUAJIT_COMPILE_OPTIONS="        \
    -std=c11                            \
    -DLITELUA_LUA_CORE=\"lua.h\"      \
    -DLITELUA_LUA_LIBS=\"lualib.h\"   \
    -DLITELUA_LUA_XLIBS=\"lauxlib.h\" \
    -DLITELUA_USING_LUAJIT=1            \
    -I$LITELUA_LUAJIT_INCLUDE           \
"

# Building library

clang -c src/litelua_luajit.c -o $LITELUA_BUILD_DIR/litelua_luajit.o $LITELUA_LUAJIT_COMPILE_OPTIONS

llvm-ar x $LITELUA_LUAJIT_LIBRARY --output $LITELUA_BUILD_DIR

llvm-ar rc $LITELUA_BUILD_DIR/liblitelua_luajit.a $LITELUA_BUILD_DIR/*.o

# Copy output files

mkdir -p $LITELUA_LUAJIT_OUTPUT/$LITELUA_PREBUILT_FOLDER

cp -r $LITELUA_LUAJIT_INCLUDE $LITELUA_LUAJIT_OUTPUT
cp -r $LITELUA_DIR/src/litelua.h $LITELUA_LUAJIT_OUTPUT/include
cp -r $LITELUA_DIR/src/litelua_config.h $LITELUA_LUAJIT_OUTPUT/include
cp -r $LITELUA_BUILD_DIR/liblitelua_luajit.a $LITELUA_LUAJIT_OUTPUT/$LITELUA_PREBUILT_FOLDER