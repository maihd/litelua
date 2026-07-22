local core = {}

local font = renderer.font.load(EXEDIR .. "/data/fonts/ZeitungMonoProNerdFont-Regular.ttf", 14 * SCALE)

-- Startup
function core.init()
    -- system.
end

-- Application loop
function core.run()
    local quit = false
    local frame_start = system.get_time()
    while not quit do
        system.begin_frame()

        -- Handle events
        for type, a, b, c, d, e in system.poll_event do
            if type == "quit" then
                quit = true
                break
            end
        end

        -- Stepping and rendering
        renderer.begin_frame()
        renderer.draw_text(font, "Hellope!", 10, 10, { 255, 255, 255, 255 })
        renderer.end_frame()

        -- Sleeping to utilize CPU for other works
        local frame_end = system.get_time()
        local elapsed = frame_end - frame_start
        local frame = 1.0 / 60

        local delta
        if frame > elapsed then
            local sleep_time = frame - elapsed
            system.sleep(sleep_time)
            frame_end = frame_end + sleep_time
            delta = frame
        else
            delta = elapsed
        end

        frame_start = frame_end

        system.end_frame()
    end
end

-- Handle error from system
function core.on_error()
    -- Write error to file
    local fp = io.open(EXEDIR .. "/error.txt", "wb")
    fp:write("Error: " .. tostring(err) .. "\n")
    fp:write(debug.traceback(nil, 4))
    fp:close()
end

return core