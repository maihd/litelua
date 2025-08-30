if [ ! -d "libs/luajit" ]; then
    git clone https://github.com/luajit/luajit.git libs/luajit --recursive --depth=1
fi

if [ ! -d "libs/luau" ]; then
    git clone https://github.com/luau-lang/luau.git libs/luau --recursive --depth=1
fi