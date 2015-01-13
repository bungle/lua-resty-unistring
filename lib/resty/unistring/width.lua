local require      = require
local lib          = require "resty.unistring.lib"
local ffi          = require "ffi"
local ffi_cdef     = ffi.cdef
ffi_cdef[[
int u8_width   (const uint8_t *s, size_t n, const char *encoding);
int u8_strwidth(const uint8_t *s, const char *encoding);
]]
local width = {}
function width.u8_width(s, n, encoding) return lib.u8_width(s, n or #s, encoding) end
function width.u8_strwidth(s, encoding) return lib.u8_strwidth(s, encoding)       end
return width
