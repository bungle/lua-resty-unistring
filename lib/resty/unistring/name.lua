local require  = require
local lib      = require "resty.unistring.lib"
local ffi      = require "ffi"
local ffi_cdef = ffi.cdef
local ffi_str  = ffi.string
local ffi_new  = ffi.new
ffi_cdef[[
char * unicode_character_name(ucs4_t uc, char *buf);
ucs4_t unicode_name_character(const char *name);
]]
local buf = ffi_new "char[256]"
local name = {}
function name.unicode_character_name(uc)
    return ffi_str(lib.unicode_character_name(uc, buf))
end
function name.unicode_name_character(name)
    return lib.unicode_name_character(name)
end

return name
