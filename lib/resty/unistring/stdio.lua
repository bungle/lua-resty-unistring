local require      = require
local lib          = require "resty.unistring.lib"
local ffi          = require "ffi"
local ffi_cdef     = ffi.cdef
local ffi_str      = ffi.string
ffi_cdef[[
int u8_sprintf (uint8_t *buf, const char *format, ...);
int u8_snprintf(uint8_t *buf, size_t size, const char *format, ...);
int u8_asprintf(uint8_t **resultp, const char *format, ...);
uint8_t * u8_asnprintf(uint8_t *resultbuf, size_t *lengthp, const char *format, ...);
]]
local result = ffi.new "uint8_t *[1]"
local stdio = {}
function stdio.u8_sprintf(buf, format, ...)
    local i = lib.u8_sprintf(buf, format, ...)
    if i < 0 then return nil, i end
    return ffi_str(buf[0], i), i
end
function stdio.u8_snprintf(buf, size, format, ...)
    local i = lib.u8_snprintf(buf, size, format, ...)
    if i < 0 then return nil, i end
    return ffi_str(buf[0], i), i
end
function stdio.u8_asprintf(format, ...)
    local i = lib.u8_asprintf(result, format, ...)
    if i == -1 then return nil, -1 end
    return ffi_str(result[0], i), i
end
return stdio
