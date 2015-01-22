local require    = require
local lib        = require "resty.unistring.lib"
local ffi        = require "ffi"
local ffi_cdef   = ffi.cdef
local ffi_str    = ffi.string
local ffi_new    = ffi.new
local ffi_gc     = ffi.gc
local ffi_typeof = ffi.typeof
local ffi_sizeof = ffi.sizeof
local ffi_copy   = ffi.copy
local C          = ffi.C
ffi_cdef[[
const uint8_t * u8_check     (const uint8_t  *s, size_t n);
uint16_t *      u8_to_u16    (const uint8_t  *s, size_t n, uint16_t *resultbuf, size_t *lengthp);
uint32_t *      u8_to_u32    (const uint8_t  *s, size_t n, uint32_t *resultbuf, size_t *lengthp);
uint8_t *       u16_to_u8    (const uint16_t *s, size_t n, uint8_t  *resultbuf, size_t *lengthp);
uint8_t *       u32_to_u8    (const uint32_t *s, size_t n, uint8_t  *resultbuf, size_t *lengthp);
int             u8_mblen     (const uint8_t *s, size_t n);
int             u16_mblen    (const uint16_t *s, size_t n);
int             u32_mblen    (const uint32_t *s, size_t n);
int             u8_mbtouc    (ucs4_t *puc, const uint8_t *s, size_t n);
int             u8_mbtoucr   (ucs4_t *puc, const uint8_t *s, size_t n);
int             u8_uctomb    (uint8_t *s, ucs4_t uc, int n);
int             u8_cmp       (const uint8_t *s1, const uint8_t *s2, size_t n);
int             u8_cmp2      (const uint8_t *s1, size_t n1, const uint8_t *s2, size_t n2);
size_t          u8_mbsnlen   (const uint8_t *s, size_t n);
size_t          u16_mbsnlen  (const uint16_t *s, size_t n);
size_t          u32_mbsnlen  (const uint32_t *s, size_t n);
int             u8_strmblen  (const uint8_t *s);
int             u8_strmbtouc (ucs4_t *puc, const uint8_t *s);
size_t          u8_strlen    (const uint8_t *s);
size_t          u8_strnlen   (const uint8_t *s, size_t maxlen);
size_t          u8_strcspn   (const uint8_t *str, const uint8_t *reject);
size_t          u8_strspn    (const uint8_t *str, const uint8_t *accept);
uint8_t *       u8_strpbrk   (const uint8_t *str, const uint8_t *accept);
uint8_t *       u8_strstr    (const uint8_t *haystack, const uint8_t *needle);
bool            u8_startswith(const uint8_t *str, const uint8_t *prefix);
bool            u8_endswith  (const uint8_t *str, const uint8_t *suffix);
uint8_t *       u8_strtok    (uint8_t *str, const uint8_t *delim, uint8_t **ptr);
]]
local uint = ffi_typeof "uint8_t[?]"
local ucs4 = ffi_new "ucs4_t[1]"
local size = ffi_new "size_t[1]"
local ui86 = ffi_new(uint, 6)
local tptr = nil
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
function str.u16_to_u8(s, n)
    return ffi_str(ffi_gc(lib.u16_to_u8(s, n or ffi_sizeof(s), nil, size), C.free), tonumber(size[0])), tonumber(size[0])
end
function str.u32_to_u8(s, n)
    return ffi_str(ffi_gc(lib.u32_to_u8(s, n or ffi_sizeof(s), nil, size), C.free), tonumber(size[0])), tonumber(size[0])
end
function str.u8_strmbtouc(s)
    local i = lib.u8_strmbtouc(ucs4, s)
    if i < 0 then return nil, i end
    return ucs4[0], i
end
function str.u8_mblen(s, n)
    return lib.u8_mblen(s, n or #s)
end
function str.u16_mblen(s, n)
    return lib.u16_mblen(s, n or ffi_sizeof(s))
end
function str.u32_mblen(s, n)
    return lib.u32_mblen(s, n or ffi_sizeof(s))
end
function str.u8_mbtouc(s, n)
    local l = lib.u8_mbtouc(ucs4, s, n or #s)
    return ucs4[0], l
end
function str.u8_mbtoucr(s, n)
    local l = lib.u8_mbtouc(ucs4, s, n or #s)
    return ucs4[0], l
end
function str.u8_uctomb(uc, n)
    ucs4[0] = uc
    local l = lib.u8_uctomb(ui86, uc, n or 6)
    return ffi_str(ui86, l), l
end
function str.u8_cmp(s1, s2, n)
    return lib.u8_cmp(s1, s2, n)
end
function str.u8_cmp2(s1, n1, s2, n2)
    return lib.u8_cmp2(s1, n1, s2, n2)
end
function str.u8_mbsnlen(s, n)
    return tonumber(lib.u8_mbsnlen(s, n or #s))
end
function str.u16_mbsnlen(s, n)
    return tonumber(lib.u16_mbsnlen(s, n or ffi_sizeof(s)))
end
function str.u32_mbsnlen(s, n)
    return tonumber(lib.u32_mbsnlen(s, n or ffi_sizeof(s)))
end
function str.u8_strmblen(s)
    return lib.u8_strmblen(s)
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
function str.u8_strtok(str, delim, ptr)
    local r
    if delim then
        local s = ffi_new(uint, #str)
        ffi_copy(s, str)
        if not ptr then tptr = ffi_new("uint8_t *[1]") end
        r = lib.u8_strtok(s, delim, ptr or tptr)
    else
        r = lib.u8_strtok(nil, str, delim or tptr)
    end
    if r == nil then return nil end
    return ffi_str(r)
end
return str