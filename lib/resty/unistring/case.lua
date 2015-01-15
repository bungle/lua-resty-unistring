local require   = require
local lib       = require "resty.unistring.lib"
local ffi       = require "ffi"
local ffi_gc    = ffi.gc
local ffi_new   = ffi.new
local ffi_cdef  = ffi.cdef
local ffi_str   = ffi.string
local ffi_errno = ffi.errno
local C         = ffi.C
local tonumber  = tonumber
ffi_cdef[[
const char * uc_locale_language(void);
uint8_t    * u8_toupper (const uint8_t *s, size_t n, const char *iso639_language, uninorm_t nf, uint8_t *resultbuf, size_t *lengthp);
uint8_t    * u8_tolower (const uint8_t *s, size_t n, const char *iso639_language, uninorm_t nf, uint8_t *resultbuf, size_t *lengthp);
uint8_t    * u8_totitle (const uint8_t *s, size_t n, const char *iso639_language, uninorm_t nf, uint8_t *resultbuf, size_t *lengthp);
uint8_t    * u8_casefold(const uint8_t *s, size_t n, const char *iso639_language, uninorm_t nf, uint8_t *resultbuf, size_t *lengthp);
int          u8_casecmp (const uint8_t *s1, size_t n1, const uint8_t *s2, size_t n2, const char *iso639_language, uninorm_t nf, int *resultp);
int          u8_casecoll(const uint8_t *s1, size_t n1, const uint8_t *s2, size_t n2, const char *iso639_language, uninorm_t nf, int *resultp);
int          u8_is_uppercase (const uint8_t *s, size_t n, const char *iso639_language, bool *resultp);
int          u8_is_lowercase (const uint8_t *s, size_t n, const char *iso639_language, bool *resultp);
int          u8_is_titlecase (const uint8_t *s, size_t n, const char *iso639_language, bool *resultp);
int          u8_is_casefolded(const uint8_t *s, size_t n, const char *iso639_language, bool *resultp);
int          u8_is_cased     (const uint8_t *s, size_t n, const char *iso639_language, bool *resultp);
]]
local int  = ffi_new "int[1]"
local size = ffi_new "size_t[1]"
local bool = ffi_new "bool[1]"
local form = {
    nfc  = lib.uninorm_nfc,
    nfd  = lib.uninorm_nfd,
    nfkc = lib.uninorm_nfkc,
    nfkd = lib.uninorm_nfkd
}
local case = {}
function case.uc_locale_language() return ffi_str(lib.uc_locale_language()) end
function case.u8_toupper (s, n, iso639_language, nf) return ffi_str(ffi_gc(lib.u8_toupper (s, n or #s, iso639_language, form[nf], nil, size), C.free), size[0]), tonumber(size[0]) end
function case.u8_tolower (s, n, iso639_language, nf) return ffi_str(ffi_gc(lib.u8_tolower (s, n or #s, iso639_language, form[nf], nil, size), C.free), size[0]), tonumber(size[0]) end
function case.u8_totitle (s, n, iso639_language, nf) return ffi_str(ffi_gc(lib.u8_totitle (s, n or #s, iso639_language, form[nf], nil, size), C.free), size[0]), tonumber(size[0]) end
function case.u8_casefold(s, n, iso639_language, nf) return ffi_str(ffi_gc(lib.u8_casefold(s, n or #s, iso639_language, form[nf], nil, size), C.free), size[0]), tonumber(size[0]) end
function case.u8_casecmp(s1, n1, s2, n2, iso639_language, nf)
    if lib.u8_casecmp(s1, n1 or #s1, s2, n2 or #s2, iso639_language, form[nf], int) == 0 then return int[0] end
    return nil, ffi_errno()
end
function case.u8_casecoll(s1, n1, s2, n2, iso639_language, nf)
    if lib.u8_casecoll(s1, n1 or #s1, s2, n2 or #s2, iso639_language, form[nf], int) == 0 then return int[0] end
    return nil, ffi_errno()
end
function case.u8_is_uppercase(s, n, iso639_language)
    if lib.u8_is_uppercase(s, n or #s, iso639_language, bool) == 0 then return bool[0] end
    return nil, ffi_errno()
end
function case.u8_is_lowercase(s, n, iso639_language)
    if lib.u8_is_lowercase(s, n or #s, iso639_language, bool) == 0 then return bool[0] end
    return nil, ffi_errno()
end
function case.u8_is_titlecase(s, n, iso639_language)
    if lib.u8_is_titlecase(s, n or #s, iso639_language, bool) == 0 then return bool[0] end
    return nil, ffi_errno()
end
function case.u8_is_casefolded(s, n, iso639_language)
    if lib.u8_is_casefolded(s, n or #s, iso639_language, bool) == 0 then return bool[0] end
    return nil, ffi_errno()
end
function case.u8_is_cased(s, n, iso639_language)
    if lib.u8_is_cased(s, n or #s, iso639_language, bool) == 0 then return bool[0] end
    return nil, ffi_errno()
end
return case
