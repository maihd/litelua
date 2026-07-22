package lua_bindgen

import "core:strings"
import "core:fmt"
import "core:os"

import "core:odin/ast"
import "core:odin/parser"

main :: proc() {
    p := parser.Parser{}

    pkg, parse_ok := parser.parse_package_from_path("lua_odin_lib")
    if !parse_ok {
        fmt.eprintf("Failed to parse package from lua_odin_lib")
        return
    }

    for file_path, file in pkg.files {
        for decl in file.decls {
            if value_decl, ok := decl.derived.(^ast.Value_Decl); ok {
                // Simply most proc decl only have 1 values
                if len(value_decl.values) != 1 {
                    continue
                }

                if proc_del, ok := value_decl.values[0].derived.(^ast.Proc_Lit); ok {
                    proc_name, proc_name_ok := get_name(value_decl.names)
                    if !proc_name_ok {
                        continue
                    }

                    fmt.printfln("%v :: proc(){{}}", proc_name)
                    
                    procbind_name := strings.concatenate({ "luabind_", proc_name })
                    fmt.printfln("%v :: proc(L: ^lua.State) -> c.int {{ context = runtime.default_context(); hellope(); return 0 }}", procbind_name)
                }
            }
        }
    }
}

get_name :: proc(exprs: []^ast.Expr) -> (string, bool) {
    for expr in exprs {
        if indent := expr.derived.(^ast.Ident); indent != nil {
            return indent.name, true
        }
    }

    return "", false
}