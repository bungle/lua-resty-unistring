-- This is a drop-in replacement to LuaJIT to support Lua 5.3 utf8 library
-- with some additional functionality for UTF-8 enabled string.xxx functions.
local sub  = string.sub
local str  = require "resty.unistring.str"
local case = require "resty.unistring.case"
local norm = require "resty.unistring.norm"
local nrmz = norm.u8_normalize
local find = string.find
local utf8 = utf8 or {}
--if not utf8.char then
--    function utf8.char(...)
--        for i = 1, select("#", ...) do
--            select(i, ...)
--        end
--    end
--end
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