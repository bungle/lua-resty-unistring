local require      = require
local ffi          = require "ffi"
local ffi_cdef     = ffi.cdef
local ffi_load     = ffi.load
ffi_cdef[[
void free (void* ptr);
const int _libunistring_version;
struct unicode_normalization_form;
typedef const struct unicode_normalization_form *uninorm_t;
const struct unicode_normalization_form uninorm_nfd;
const struct unicode_normalization_form uninorm_nfc;
const struct unicode_normalization_form uninorm_nfkd;
const struct unicode_normalization_form uninorm_nfkc;
typedef uint32_t ucs4_t;
]]
return ffi_load "libunistring"