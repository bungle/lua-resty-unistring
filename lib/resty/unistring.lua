local require = require
local lib     = require "resty.unistring.lib"
local bit     = require("bit")
local rshift  = bit.rshift
local band    = bit.band
local us = {}
us.version = rshift(lib._libunistring_version, 16) .. "." .. rshift(lib._libunistring_version, 8) .. "." .. band(lib._libunistring_version, 0xFF)
us.str     = require "resty.unistring.str"
us.case    = require "resty.unistring.case"
us.norm    = require "resty.unistring.norm"
us.width   = require "resty.unistring.width"
us.stdio   = require "resty.unistring.stdio"
us.buf     = require "resty.unistring.buf"
return us
