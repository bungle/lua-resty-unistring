local require      = require
local lib          = require "resty.unistring"
local ffi          = require "ffi"
local ffi_new      = ffi.new
local ffi_cdef     = ffi.cdef
local ffi_str      = ffi.string

ffi_cdef[[
const char * uc_locale_language(void);
uint8_t    * u8_toupper(const uint8_t *s, size_t n, const char *iso639_language, uninorm_t nf, uint8_t *resultbuf, size_t *lengthp);
uint8_t    * u8_tolower(const uint8_t *s, size_t n, const char *iso639_language, uninorm_t nf, uint8_t *resultbuf, size_t *lengthp);
uint8_t    * u8_totitle(const uint8_t *s, size_t n, const char *iso639_language, uninorm_t nf, uint8_t *resultbuf, size_t *lengthp);
int          u8_is_uppercase(const uint8_t *s, size_t n, const char *iso639_language, bool *resultp);
int          u8_is_lowercase(const uint8_t *s, size_t n, const char *iso639_language, bool *resultp);
int          u8_is_titlecase(const uint8_t *s, size_t n, const char *iso639_language, bool *resultp);
]]


local size   = ffi_new("size_t[1]")
local bool   = ffi_new("bool[1]")

local lang = lib.uc_locale_language()
local case = {}

function case.uc_locale_language()            return ffi_str(lang) end
function case.u8_toupper (s, n, language, nf) return ffi_str(lib.u8_toupper (s, n or #s, language or lang, nil, nil, size)), tonumber(size[0]) end
function case.u8_tolower (s, n, language, nf) return ffi_str(lib.u8_tolower (s, n or #s, language or lang, nil, nil, size)), tonumber(size[0]) end
function case.u8_totitle (s, n, language, nf) return ffi_str(lib.u8_totitle (s, n or #s, language or lang, nil, nil, size)), tonumber(size[0]) end
function case.u8_is_uppercase(s, n, language)
    if lib.u8_is_uppercase(s, n or #s, language or lang, bool) == 0 then return bool[0] end
    return nil
end
function case.u8_is_lowercase(s, n, language)
    if lib.u8_is_lowercase(s, n or #s, language or lang, bool) == 0 then return bool[0] end
    return nil
end
function case.u8_is_titlecase(s, n, language)
    if lib.u8_is_titlecase(s, n or #s, language or lang, bool) == 0 then return bool[0] end
    return nil
end

return case