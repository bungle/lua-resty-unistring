-- This is a drop-in replacement to LuaJIT to support Lua 5.3 utf8 library
-- with some additional functionality for UTF-8 enabled string.xxx functions.
local sub  = string.sub
local str  = require "resty.unistring.str"
local case = require "resty.unistring.case"
local find = string.find
if not utf8 then
    utf8 = {}
    utf8.charpattern = "[\0-\x7F\xC2-\xF4][\x80-\xBF]*"
    function utf8.len(s, i, j)
        local x = sub(s, i or 1, j or -1)
        local e = str.u8_check(x, #x)
        if e == nil then
            return str.u8_mbsnlen(x, #x)
        end
        return nil, (find(s, e, 1, true))
    end
end
if not ut8.lower then
    function utf8.lower(s)
        return case.u8_tolower(s)
    end
end
if not ut8.upper then
    function utf8.upper(s)
        return case.u8_toupper(s)
    end
end