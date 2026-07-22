-- Stopping auto GC
collectgarbage("stop")

-- Doing incremental gc with time-budgeting
function gc(time_ms)
    local current = os.clock()
    while time_ms > 0 do
        collectgarbage("collect", 1)

        local clock = os.clock()
        time_ms = time_ms - (clock - current)
        current = clock
    end
end

-- In your game loop
while true do
    
    -- End of a frame
    local elapsed_ms = get_frame_elapsed()
    gc(elapsed_ms)

    -- Calculate delta
    
end