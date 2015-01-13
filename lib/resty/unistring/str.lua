local require      = require
local lib          = require "resty.unistring.lib"
local ffi          = require "ffi"
local ffi_cdef     = ffi.cdef
local ffi_str      = ffi.string
ffi_cdef[[
const uint8_t * u8_check (const uint8_t *s, size_t n);
int             u8_mblen(const uint8_t *s, size_t n);
size_t          u8_mbsnlen(const uint8_t *s, size_t n);
size_t          u8_strlen(const uint8_t *s);
bool            u8_startswith(const uint8_t *str, const uint8_t *prefix);
bool            u8_endswith(const uint8_t *str, const uint8_t *suffix);
]]
local str = {}
function str.u8_check(s, n)
    local ok = lib.u8_check(s, n or #s)
    if ok == nil then return nil end
    return ffi_str(ok, 1)
end
function str.u8_mblen(s, n)           return lib.u8_mblen(s, n or #s)             end
function str.u8_mbsnlen(s, n)         return tonumber(lib.u8_mbsnlen(s, n or #s)) end
function str.u8_strlen(s)             return tonumber(lib.u8_strlen(s))           end
function str.u8_startswith(s, prefix) return lib.u8_startswith(s, prefix)         end
function str.u8_endswith(s, suffix)   return lib.u8_endswith(s, suffix)           end
return str