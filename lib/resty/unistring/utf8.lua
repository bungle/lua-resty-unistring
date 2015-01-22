-- This is a drop-in replacement to LuaJIT to support Lua 5.3 utf8 library
-- with some additional functionality for UTF-8 enabled string.xxx functions.
local assert  = assert
local format  = string.format
local concat  = table.concat
local type    = type
local sub     = string.sub
local ffi     = require "ffi"
local ffi_new = ffi.new
local ffi_str = ffi.string
local buf     = require "resty.unistring.buf"
local lib     = require "resty.unistring.lib"
local str     = require "resty.unistring.str"
local case    = require "resty.unistring.case"
local norm    = require "resty.unistring.norm"
local nrmz    = norm.u8_normalize
local find    = string.find
if not ok then newtab = function() return {} end end
local function posrelat(i, l)
    if i >= 0    then return i end
    if 0 - i > l then return 0 end
    return l + i + 1;
end
local utf8 = utf8 or {}
if not utf8.char then
    function utf8.char(...)
        local n = select("#", ...)
        local r = newtab(n, 0)
        for i = 1, n do
            local v = select(i, ...)
            assert(type(v) == "number", format("bad argument #%d to 'char' (number expected, got string)", i))
            r[i] = str.u8_uctomb(v)
        end
        return concat(r)
    end
end
if not utf8.charpattern then
    utf8.charpattern = "[\0-\x7F\xC2-\xF4][\x80-\xBF]*"
end
--if not utf8.codes then
--    function utf8.codes(s)
--    end
--end
--if not utf8.codepoint then
--    function utf8.codepoint(s, i, j)
--    end
--end
if not utf8.len then
    function utf8.len(s, i, j)
        local x = sub(s, i or 1, j or -1)
        local e = str.u8_check(x, #x)
        if e == nil then
            return str.u8_mbsnlen(x, #x)
        end
        return nil, (find(s, e, 1, true))
    end
end
--if not utf8.offset then
--    function utf8.offset(s, n, i)
--        local st = type(s)
--        local nt = type(n)
--        assert(st == "string" or st == "number", string.format("bad argument #1 to 'offset' (string expected, got %s)", st))
--        assert(nt == "number",                   string.format("bad argument #2 to 'offset' (string expected, got %s)", nt))
--        local p = i or (n < 0 and #s + 1 or 1)
--        local pt = type(p)
--        assert(it == "number",                   string.format("bad argument #2 to 'offset' (string expected, got %s)", it))
--        local l = #s;
--    end
--end
if not utf8.lower then
    function utf8.lower(s)
        return case.u8_tolower(s)
    end
end
if not utf8.upper then
    function utf8.upper(s)
        return case.u8_toupper(s)
    end
end
if not utf8.title then
    function utf8.title(s)
        return case.u8_totitle(s)
    end
end
if not utf8.starts then
    function utf8.starts(s, prefix)
        return case.u8_startswith(s, prefix)
    end
end
if not utf8.ends then
    function utf8.ends(s, suffix)
        return case.u8_endswith(s, suffix)
    end
end
if not utf8.split then
    function utf8.split(s, delim)
        local t = {}
        local s = str.u8_strtok(s, delim)
        while s ~= nil do
            t[#t+1] = s
            s = str.u8_strtok(delim)
        end
        return t
    end
end
if not utf8.sub then
    function utf8.sub(s, i, j)
        local t = type(i)
        assert(t == "number", format("bad argument #2 to 'sub' (number expected, got %s)", t))
        local l = lib.u8_mbsnlen(s, #s)
        i = posrelat(i, l)
        j = posrelat(j or -1, l)
        if i < 1 then i = 1 end
        if j > l then j = l end
        i = tonumber(i)
        j = tonumber(j)
        if i <= j then
            local u = ffi_new "ucs4_t[1]"
            for _ = 2, i do
                s = lib.u8_next(u, s)
            end
            local l = j - i + 1
            return ffi_str(lib.u8_move(buf(l), s, l), l)
        end
        return ""
    end
end
if not utf8.reverse then
    function utf8.reverse(s)
        local u = ffi_new "ucs4_t[1]"
        local l = tonumber(lib.u8_mbsnlen(s, #s))
        local r = newtab(l, 0)
        for i = l, 1, -1 do
            s = lib.u8_next(u, s)
            r[i] = str.u8_uctomb(u[0])
        end
        return table.concat(r)
    end
end
if not utf8.slug then
    function utf8.slug(s)
        if not ngx then return nil end
        local gsub = ngx.re.gsub
        s = nrmz("nfkd", s)
        if not s then return nil end
        s = gsub(s, "\\p{Mn}", "", "u")
        if not s then return nil end
        s = gsub(s, "\\W", "-")
        if not s then return nil end
        s = gsub(s, "\\-{2,}", "-")
        if not s then return nil end
        local i, j = 1, #s
        if sub(s, i, i) == "-" then i = i + 1 end
        if sub(s, j, j) == "-" then j = j - 1 end
        return sub(s, i, j)
    end
end
--if not _G.utf8 then _G.utf8 = utf8 end
return utf8