if command -v figlet &> /dev/null; then
    figlet "Building LiteLua Luau"
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

LITELUA_LUAU_FOLDER="$LITELUA_DIR/libs/luau"
LITELUA_LUAU_INCLUDE="$LITELUA_LUAU_FOLDER/include"
LITELUA_LUAU_LIBRARY="$LITELUA_LUAU_FOLDER/$LITELUA_PREBUILT_FOLDER"
LITELUA_LUAU_OUTPUT="$LITELUA_OUTPUT/litelua_luau"

    # -target x86_64-pc-windows-msvc ^
LITELUA_LUAU_COMPILE_OPTIONS="          \
    -std=c11                            \
    -DLITELUA_LUAU_CORE=\"lua.h\"       \
    -DLITELUA_LUAU_LIBS=\"lualib.h\"    \
    -DLITELUA_LUAU_CODE=\"luacode.h\"   \
    -DLITELUA_USING_LUAU=1              \
    -I$LITELUA_LUAU_INCLUDE             \
"

# Building library

clang -c src/litelua_luau.c -o $LITELUA_BUILD_DIR/litelua_luau.o $LITELUA_LUAU_COMPILE_OPTIONS

llvm-ar x $LITELUA_LUAU_LIBRARY/libLuau.Config.a --output $LITELUA_BUILD_DIR
llvm-ar x $LITELUA_LUAU_LIBRARY/libLuau.Require.a --output $LITELUA_BUILD_DIR
llvm-ar x $LITELUA_LUAU_LIBRARY/libLuau.RequireNavigator.a --output $LITELUA_BUILD_DIR
llvm-ar x $LITELUA_LUAU_LIBRARY/libLuau.Compiler.a --output $LITELUA_BUILD_DIR
llvm-ar x $LITELUA_LUAU_LIBRARY/libLuau.Ast.a --output $LITELUA_BUILD_DIR
llvm-ar x $LITELUA_LUAU_LIBRARY/libLuau.VM.a --output $LITELUA_BUILD_DIR

llvm-ar rc $LITELUA_BUILD_DIR/liblitelua_luau.a $LITELUA_BUILD_DIR/*.o

# Copy output files

mkdir -p $LITELUA_LUAU_OUTPUT/include
mkdir -p $LITELUA_LUAU_OUTPUT/$LITELUA_PREBUILT_FOLDER

cp -r $LITELUA_LUAU_INCLUDE $LITELUA_LUAU_OUTPUT
cp -r $LITELUA_DIR/src/litelua.h $LITELUA_LUAU_OUTPUT/include
cp -r $LITELUA_DIR/src/litelua_config.h $LITELUA_LUAU_OUTPUT/include
cp -r $LITELUA_BUILD_DIR/liblitelua_luau.a $LITELUA_LUAU_OUTPUT/$LITELUA_PREBUILT_FOLDER