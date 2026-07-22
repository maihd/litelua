package lua_hot_reload

import "core:strings"
import "core:time"
import "core:thread"
import "core:fmt"
import "core:os"

import lua "vendor:lua/5.1"

main :: proc() {
    state := lua.L_newstate()
    defer lua.close(state)

    lua.L_openlibs(state)

    modtime: time.Time

    exedir := os.get_executable_directory(context.allocator) or_else ""
    defer delete(exedir)

    path := os.join_path({ exedir, "lua_hot_reload/main.lua" }, context.allocator) or_else "lua_hot_reload/main.lua"
    defer delete(path)

    for {
        file_info, err := os.stat(path, context.allocator)
        if err == nil {
            defer delete(file_info.fullpath)
            // defer delete(file_info.name)

            if modtime._nsec < file_info.modification_time._nsec {
                fmt.printfln("[System] %s was changed!", path)

                modtime = file_info.modification_time

                file_data, _ := os.read_entire_file(path, context.allocator)
                defer delete(file_data)

                code := strings.clone_to_cstring(string(file_data))
                defer delete(code)

                err := lua.L_dostring(state, code)
                if err != 0 {
                    error := lua.tostring(state, -1)
                    fmt.printfln("[System] Execute error: %v", error)

                    lua.pop(state, -1)
                }
            }
        }

        time.sleep(10 * time.Millisecond)
    }
}