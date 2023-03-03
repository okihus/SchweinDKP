local Name = ...

local Addon = select(2, ...)
local Locale = Addon.Locale
local lang = "enUS"

local L = {lang = lang}
setmetatable(L, Locale.MT)
Locale[lang] = L


local L = LibStub("AceLocale-3.0"):NewLocale(Name, lang, lang == Locale.FALLBACK)
if not L then return end

-- Options
L["OPT_ENABLE"] = "Enable"
L["OPT_ENABLE_DESC"] = "Enable or disable this addon"