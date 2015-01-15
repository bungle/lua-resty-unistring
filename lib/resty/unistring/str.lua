local require  = require
local lib      = require "resty.unistring.lib"
local ffi      = require "ffi"
local ffi_cdef = ffi.cdef
local ffi_str  = ffi.string
local ffi_new  = ffi.new
local ffi_gc   = ffi.gc
local C        = ffi.C
ffi_cdef[[
const uint8_t * u8_check     (const uint8_t *s, size_t n);
uint16_t *      u8_to_u16    (const uint8_t *s, size_t n, uint16_t *resultbuf, size_t *lengthp);
uint32_t *      u8_to_u32    (const uint8_t *s, size_t n, uint32_t *resultbuf, size_t *lengthp);
int             u8_strmbtouc (ucs4_t *puc, const uint8_t *s);
int             u8_mblen     (const uint8_t *s, size_t n);
size_t          u8_mbsnlen   (const uint8_t *s, size_t n);
size_t          u8_strlen    (const uint8_t *s);
size_t          u8_strnlen   (const uint8_t *s, size_t maxlen);
size_t          u8_strcspn   (const uint8_t *str, const uint8_t *reject);
size_t          u8_strspn    (const uint8_t *str, const uint8_t *accept);
uint8_t *       u8_strpbrk   (const uint8_t *str, const uint8_t *accept);
uint8_t *       u8_strstr    (const uint8_t *haystack, const uint8_t *needle);
bool            u8_startswith(const uint8_t *str, const uint8_t *prefix);
bool            u8_endswith  (const uint8_t *str, const uint8_t *suffix);
]]
local ucs4 = ffi_new "ucs4_t[1]"
local size = ffi_new "size_t[1]"
local str = {}
function str.u8_check(s, n)
    local ok = lib.u8_check(s, n or #s)
    if ok == nil then return nil end
    return ffi_str(ok, 1)
end
function str.u8_to_u16(s, n)
    return ffi_gc(lib.u8_to_u16(s, n or #s, nil, size), C.free), tonumber(size[0])
end
function str.u8_to_u32(s, n)
    return ffi_gc(lib.u8_to_u32(s, n or #s, nil, size), C.free), tonumber(size[0])
end
function str.u8_strmbtouc(s)
    local i = lib.u8_strmbtouc(ucs4, s)
    if i < 0 then return nil, i end
    return ucs4[0], i
end
function str.u8_mblen(s, n)
    return lib.u8_mblen(s, n or #s)
end
function str.u8_mbsnlen(s, n)
    return tonumber(lib.u8_mbsnlen(s, n or #s))
end
function str.u8_strlen(s)
    return tonumber(lib.u8_strlen(s))
end
function str.u8_strnlen(s, maxlen)
    return tonumber(lib.u8_strnlen(s, maxlen or #s))
end
function str.u8_strcspn(str, accept)
    return tonumber(lib.u8_strcspn(str, accept))
end
function str.u8_strspn(str, accept)
    return tonumber(lib.u8_strspn(str, accept))
end
function str.u8_strpbrk(haystack, needle)
    local s = lib.u8_strpbrk(haystack, needle)
    if s == nil then return nil end
    return ffi_str(s)
end
function str.u8_strstr(haystack, accept)
    local s = lib.u8_strstr(haystack, accept)
    if s == nil then return nil end
    return ffi_str(s)
end
function str.u8_startswith(s, prefix)
    return lib.u8_startswith(s, prefix)
end
function str.u8_endswith(s, suffix)
    return lib.u8_endswith(s, suffix)
end
return str