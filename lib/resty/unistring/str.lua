local require      = require
local lib          = require "resty.unistring"
local ffi          = require "ffi"
local ffi_cdef     = ffi.cdef

ffi_cdef[[
int    u8_mblen(const uint8_t *s, size_t n);
size_t u8_mbsnlen(const uint8_t *s, size_t n);
size_t u8_strlen(const uint8_t *s);
bool u8_startswith(const uint8_t *str, const uint8_t *prefix);
bool u8_endswith(const uint8_t *str, const uint8_t *suffix);
]]

local str = {}

function str.u8_mblen(s, n)           return lib.u8_mblen(s, n or #s)             end
function str.u8_mbsnlen(s, n)         return tonumber(lib.u8_mbsnlen(s, n or #s)) end
function str.u8_strlen(s)             return tonumber(lib.u8_strlen(s))           end
function str.u8_startswith(s, prefix) return lib.u8_startswith(s, prefix)         end
function str.u8_endswith(s, suffix)   return lib.u8_endswith(s, suffix)           end

return str