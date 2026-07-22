local safe_env = {
    -- Allow safe native Lua utilities
    print = print,
    tostring = tostring,
    next = next,
    pairs = pairs,
    ipairs = ipairs,
    type = type,
    select = select,
    assert = assert,
    error = error,

    -- Allow safe core libraries
    math = math,
    string = string,
    table = table,

    -- Expose specific api
    import = import
}

safe_env._G = safe_env

-- Track already loaded files to prevent duplicate execution
local imported_files = {}

-- Define sanboxed import
function import(filename)
    if imported_files[filename] then
        return
    end

    local chunk, err = loadfile(filename)
    if not chunk then
        error("Sandbox import error: Failed to load file " .. filename .. "\n" .. tostring(err))
    end

    if _VERSION == "Lua 5.1" then
        setfenv(chunk, safe_env)
    else
        local debug = require("debug")
        if debug and debug.setupvalue then
            debug.setupvalue(chunk, 1, safe_env)
        end
    end

    chunk()
    imported_files[filename] = true
end

safe_env.import = import
import "sandbox_code.lua"