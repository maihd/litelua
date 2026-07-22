local ffi = require("ffi")

-- ffi.cdef [[
--     // Intrinsic to read the CPU time-stamp counter
--     uint64_t __rdtsc(void);
-- ]]

return {
    time = os.time
}