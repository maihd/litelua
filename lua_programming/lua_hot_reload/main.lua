print("Hellope!")

if not State then
    State = { isPlaying = false, playerName = "MaiHD" }
end

function table_value_to_string(v)
    if type(v) == "table" then
        return table_to_string(v)
    elseif type(v) == "string" then
        return "\"" .. v .. "\""
    else
        return tostring(v)
    end
end

function table_to_string(t) 
    local result = "{"
    for k, v in pairs(t) do
        result = result .. k .. " = " .. table_value_to_string(v) .. ","
    end 

    result = result .. "}"
    return result
end

print(table_to_string(State))