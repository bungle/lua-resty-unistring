local require    = require
local lib        = require "resty.unistring.lib"
local ffi        = require "ffi"
local ffi_cdef   = ffi.cdef
local ffi_str    = ffi.string
local ffi_new    = ffi.new
local ffi_typeof = ffi.typeof
ffi_cdef[[
struct unicode_normalization_form;
typedef const struct unicode_normalization_form *uninorm_t;
uint8_t * u8_normalize(uninorm_t nf, const uint8_t *s, size_t n, uint8_t *resultbuf, size_t *lengthp);
]]
local size = ffi_new "size_t[1]"
local uint8t = ffi_typeof "uint8_t[?]"
local form = {
    c  = lib.uninorm_nfc,
    d  = lib.uninorm_nfd,
    kc = lib.uninorm_nfkc,
    kd = lib.uninorm_nfkd
}
local norm = {}
function norm.u8_normalize(nf, s)
    if type(nf) == "string" then nf = form[nf] end
    if not nf then return nil, -1 end
    local l = #s
    lib.u8_normalize(nf, s, l, nil, size)
    local b = ffi_new(uint8t, size[0])
    lib.u8_normalize(nf, s, l, b, size)
    return ffi_str(b, size[0])
end
return norm